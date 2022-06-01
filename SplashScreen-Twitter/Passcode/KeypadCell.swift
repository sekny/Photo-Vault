//
//  KeypadCell.swift
//  SplashScreen-Twitter
//
//  Created by YIM SEKNY on 23/5/22.
//

import UIKit

class KeypadCell: UICollectionViewCell {

    @IBOutlet weak var btnKeypad: UIButton!
    static let cellIdentifier = "KeypadCellIdentifier"
    static let cellNib = UINib.init(nibName: "KeypadCell", bundle: Bundle.main)
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setTitle(title: String) {
        btnKeypad.setTitle(title, for: .normal)
    }
    
    func setImage(image: UIImage){
        btnKeypad.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        btnKeypad.imageView?.contentMode = .scaleAspectFit
        btnKeypad.contentHorizontalAlignment = .center
    }
}

