//
//  ListViewCell.swift
//  SplashScreen-Twitter
//
//  Created by YIM SEKNY on 25/5/22.
//

import UIKit

class ListViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var contentViewOverlay: UIView!
    @IBOutlet weak var tickIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()

        tickIcon.layer.borderWidth = 1
        tickIcon.layer.masksToBounds = false
        tickIcon.layer.borderColor = UIColor.systemBlue.cgColor
        tickIcon.layer.cornerRadius = tickIcon.frame.height/2
        tickIcon.clipsToBounds = true
        tickIcon.isHidden = true
        contentViewOverlay.isHidden = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setImage(image: UIImage) {
        self.imageView.image = image
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.backgroundColor = .lightGray
    }
    
    func showTickIcon() {
        self.tickIcon.isHidden = false
        self.isSelected = true
        self.contentViewOverlay.isHidden = false
    }
    func hideTickIcon() {
        self.tickIcon.isHidden = true
        self.isSelected = false
        self.contentViewOverlay.isHidden = true
    }
}
