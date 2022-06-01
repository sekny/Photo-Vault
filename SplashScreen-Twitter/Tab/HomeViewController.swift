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

class HomeViewController: UITabBarController, UITabBarControllerDelegate, PHPickerViewControllerDelegate {
    var phPickerConfig = PHPickerConfiguration(photoLibrary: .shared())
    var viewModel = DocumentViewModel()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupMiddleButton()
        phPickerConfig.selectionLimit = 500
        phPickerConfig.filter = PHPickerFilter.any(of: [.images])
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
           DispatchQueue.main.async {
               print("Queue")
               print(image.size)
               // TODO: - Here you get UIImage
           }
           result.itemProvider.loadFileRepresentation(forTypeIdentifier: "public.image") { [weak self] url, _ in
               let imageData = NSData(contentsOf: url!)
               if imageData != nil {
                   let input = Document()
                   input.file = imageData
                   
                   self?.insertFile(input)
               }
           }
        }
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
//            if let url = url {
//                // ok but there's a problem: the file wants to be deleted
//                // so I use `main.sync` to pin it down long enough to configure the presentation
//                DispatchQueue.main.sync {
//                    // this type is private but I don't see how else to know it loops
//                    let loopType = "com.apple.private.auto-loop-gif"
//                    if prov.hasItemConformingToTypeIdentifier(loopType) {
//                        print("looping movie")
//                        self.showLoopingMovie(url: url)
//                    } else {
//                        print("normal movie")
//                        self.showMovie(url: url)
//                    }
//                }
//            }
        }
    }
    
    func insertFile(_ entity: Document) {
        viewModel.insertObject(entity)
    }
    
    // TabBarButton – Setup Middle Button
    func setupMiddleButton() {
        let middleBtn = UIButton(frame: CGRect(x: (self.view.bounds.width / 2) - 35, y: -30, width: 70, height: 70))
        
        //STYLE THE BUTTON YOUR OWN WAY
        middleBtn.setIcon(icon: .fontAwesomeSolid(.plus), iconSize: 20.0, color: UIColor.white, backgroundColor: UIColor.white, forState: .normal)
        middleBtn.applyGradient(colors: [UIColor.lightDark().cgColor, UIColor.textColor().cgColor])
        
        //add to the tabbar and add click event
        self.tabBar.addSubview(middleBtn)
        middleBtn.addTarget(self, action: #selector(self.menuButtonAction), for: .touchUpInside)
        
        self.tabBar.items?[2].isEnabled = false
        self.tabBar.tintColor = UIColor.textColor()
        self.view.layoutIfNeeded()
    }

    // Menu Button Touch Action
    @objc func menuButtonAction(sender: UIButton) {
        print("Press Upload")
        let phPickerVC = PHPickerViewController(configuration: phPickerConfig)
        phPickerVC.delegate = self
        present(phPickerVC, animated: true)
    }
    
}
//
//struct ImageHeaderData{
//    static var PNG: [UInt8] = [0x89]
//    static var JPEG: [UInt8] = [0xFF]
//    static var GIF: [UInt8] = [0x47]
//    static var TIFF_01: [UInt8] = [0x49]
//    static var TIFF_02: [UInt8] = [0x4D]
//}
//
//extension NSData{
//    var imageFormat: ImageFormat{
//        var buffer = [UInt8](repeating: 0, count: 1)
//        self.getBytes(&buffer, range: NSRange(location: 0,length: 1))
//        if buffer == ImageHeaderData.PNG
//        {
//            return .PNG
//        } else if buffer == ImageHeaderData.JPEG
//        {
//            return .JPEG
//        } else if buffer == ImageHeaderData.GIF
//        {
//            return .GIF
//        } else if buffer == ImageHeaderData.TIFF_01 || buffer == ImageHeaderData.TIFF_02{
//            return .TIFF
//        } else{
//            return .Unknown
//        }
//    }
//}
