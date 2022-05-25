//
//  PasscodeViewController.swift
//  SplashScreen-Twitter
//
//  Created by YIM SEKNY on 23/5/22.
//

import UIKit

class PasscodeViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var pinContainerView: UIStackView!
    @IBOutlet weak var pin1: ANCustomView!
    @IBOutlet weak var pin2: ANCustomView!
    @IBOutlet weak var pin3: ANCustomView!
    @IBOutlet weak var pin4: ANCustomView!
    @IBOutlet weak var keyPadCollection: UICollectionView!
    var pincode = ""
    let cellWidth:CGFloat = 50
    let keyValues = ["1", "2", "3", "4", "5", "6", "7", "8", "9","a","0","x"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        self.view.backgroundColor = UIColor.bgColor()
        fillDotColor()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        keyPadCollection.collectionViewLayout = layout
        keyPadCollection.register(KeypadCell.cellNib, forCellWithReuseIdentifier: KeypadCell.cellIdentifier)
        keyPadCollection.delegate = self
        keyPadCollection.dataSource = self
        keyPadCollection.reloadData()
    }
    
    
    private func onTapped(_ index: Int) {
        let value = keyValues[index]
        if(value == "x") {
            pincode = String(pincode.count == 0 ? "" : pincode.dropLast())
            fillDotColor()
        } else {
            pincode += value
            fillDotColor()
            if(pincode.count == 4) {
                if(pincode == "9999") {
                    pincode = ""
                    let lenght = self.navigationController?.previousViewController()
                    print(lenght)
                    ScreenProtectionHelper.shared.hidePrivacyProtectionWindow()
                    self.dismiss(animated: true)
                    let vc = HomeViewController.instantiateVC(storyboardName: Storyboards.Home.rawValue)
                    self.view.window?.rootViewController = vc
                } else {
                    self.pinContainerView.shake(isVibrate: true)
                }
                self.pincode = ""
                fillDotColor()
            }
        }
    }
    
    
    private func fillDotColor() {
        for item in 1...4 {
            pinContainerView.arrangedSubviews[item - 1].backgroundColor = item <= pincode.count ?  UIColor.textColor() : UIColor.lightDark()
        }
    }
}



extension PasscodeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func config(index: Int,cell:KeypadCell){
        if index == 9 {
            cell.setTitle(title: "")
            
        } else if index == 11 {
            cell.setTitle(title: "")
            cell.setImage(image: UIImage(named: "img_backspace") ?? UIImage())
        } else {
            cell.setTitle(title: keyValues[index])
        }
        cell.btnKeypad.isUserInteractionEnabled = false
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keyValues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeypadCell.cellIdentifier, for: indexPath) as? KeypadCell else {
            return UICollectionViewCell()
        }
        
        config(index: indexPath.row, cell: cell)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = (keyPadCollection.frame.size.height - 5) / 4
        let width = (keyPadCollection.frame.size.width - 5) / 3
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onTapped(indexPath.row)
    }
    
}
