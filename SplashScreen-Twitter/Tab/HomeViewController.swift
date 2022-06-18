//
//  HomeViewController.swift
//  SplashScreen-Twitter
//
//  Created by YIM SEKNY on 24/5/22.
//

import UIKit
import SwiftIcons
import PhotosUI
import RealmSwift
import SnapKit

class HomeViewController: UITabBarController, UITabBarControllerDelegate, PHPickerViewControllerDelegate {
    var phPickerConfig = PHPickerConfiguration(photoLibrary: .shared())
    var viewModel = DocumentViewModel()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setup()
        setupMiddleButton()
        phPickerConfig.selectionLimit = 500
        phPickerConfig.filter = PHPickerFilter.any(of: [.images])
    }
    
    func setup() {
        self.tabBar.items?[2].isEnabled = true
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: .none)
        results.forEach { result in
            let prov = result.itemProvider
            
            if prov.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                self.readVideo(result)
            } else if prov.canLoadObject(ofClass: UIImage.self) {
                self.readImage(result)
            }
         }
    }
    
    func readImage(_ result: PHPickerResult) {
        result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
           guard let image = reading as? UIImage, error == nil else { return }
           result.itemProvider.loadFileRepresentation(forTypeIdentifier: "public.image") { [weak self] url, _ in
               let input = Document()
               let imageData = NSData(contentsOf: url!)
               guard let croppedImage = self?.saveImageToPath(image) else { return }
               if imageData != nil {
                   input.file = imageData
                   input.thumnail = NSData(data: croppedImage)
                   self?.insertFile(input)
               }
           }
        }
    }
    
    func saveImageToPath(_ sourceImage: UIImage) -> Data? {
        let targetSize = CGSize(width: 100, height: 100)

        // Compute the scaling ratio for the width and height separately
        let widthScaleRatio = targetSize.width / sourceImage.size.width
        let heightScaleRatio = targetSize.height / sourceImage.size.height

        // To keep the aspect ratio, scale by the smaller scaling ratio
        let scaleFactor = min(widthScaleRatio, heightScaleRatio)

        // Multiply the original image’s dimensions by the scale factor
        // to determine the scaled image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: sourceImage.size.width * scaleFactor,
            height: sourceImage.size.height * scaleFactor
        )
        
        let renderer = UIGraphicsImageRenderer(size: scaledImageSize)
        let scaledImage = renderer.image { _ in
            sourceImage.draw(in: CGRect(origin: .zero, size: scaledImageSize))
        }
        
        // The shortest side
        let sideLength = min(
            sourceImage.size.width,
            sourceImage.size.height
        )

        // Determines the x,y coordinate of a centered
        // sideLength by sideLength square
        let sourceSize = sourceImage.size
        let xOffset = (sourceSize.width - sideLength) / 2.0
        let yOffset = (sourceSize.height - sideLength) / 2.0

        // The cropRect is the rect of the image to keep,
        // in this case centered
        let cropRect = CGRect(
            x: xOffset,
            y: yOffset,
            width: sideLength,
            height: sideLength
        ).integral

        // Center crop the image
        let sourceCGImage = sourceImage.cgImage!
        let croppedCGImage = sourceCGImage.cropping(
            to: cropRect
        )!
        
        
        // Use the cropped cgImage to initialize a cropped
        // UIImage with the same image scale and orientation
//        let croppedImage = UIImage(
//            cgImage: croppedCGImage,
//            scale: sourceImage.imageRendererFormat.scale,
//            orientation: sourceImage.imageOrientation
//        )
        
//        guard let compressImageData = croppedImage.jpeg(.low) else { return nil }
//        guard let compressImage = UIImage(data: compressImageData) else { return nil }
        
        
        // Test change resolution
        let scaledImage1 = sourceImage.scalePreservingAspectRatio(
            targetSize: CGSize(width: 200, height: 200)
        )
        guard let compressImageData = scaledImage1.jpeg(.highest) else { return nil }
//        guard let compressImage = UIImage(data: compressImageData) else { return nil }
//        
//        UIImageWriteToSavedPhotosAlbum(compressImage , nil, nil, nil)
        
        
        
        return compressImageData
    }
    
    func readVideo(_ result: PHPickerResult) {
        // this is the hardest case
        // there is no class that represents "a movie"
        // plus, we don't want the movie in memory, we want a file on disk
        // so ask the provider to save the data for us
        let movie = UTType.movie.identifier // "com.apple.quicktime-movie"
        let prov = result.itemProvider
        // NB we could have a Progress here if we want one
        prov.loadFileRepresentation(forTypeIdentifier: movie) { url, err in
            let videoData = NSData(contentsOf: url!)
            if videoData != nil {
                let input = Document()
                input.file = videoData
                input.isImage = false
                
                self.insertFile(input)
            }
        }
    }
    
    func insertFile(_ entity: Document) {
        viewModel.insertObject(entity)
    }
    
    // TabBarButton – Setup Middle Button
    func setupMiddleButton() {
        let middleBtn = UIButton(type: .custom)
        //STYLE THE BUTTON YOUR OWN WAY
        
        //add to the tabbar and add click event
        self.view.addSubview(middleBtn)
        middleBtn.snp.makeConstraints { con in
            con.width.height.equalTo(70)
            con.center.equalTo(self.tabBar)
            con.bottom.equalTo(self.tabBar).offset(-45)
        }
        
        middleBtn.setIcon(icon: .fontAwesomeSolid(.plus), iconSize: 20.0, color: UIColor.white, backgroundColor: UIColor.white, forState: .normal)
        middleBtn.applyGradient(colors: [UIColor.lightDark().cgColor, UIColor.textColor().cgColor])
        
        middleBtn.addTarget(self, action: #selector(self.menuButtonAction), for: .touchUpInside)

        self.tabBar.tintColor = UIColor.textColor()
        self.view.layoutIfNeeded()
    }
    
    // Menu Button Touch Action
    @objc func menuButtonAction(_ sender: UITapGestureRecognizer? = nil) {
        print("Press Upload")
        let phPickerVC = PHPickerViewController(configuration: phPickerConfig)
        phPickerVC.delegate = self
        present(phPickerVC, animated: true)
    }
    
}
