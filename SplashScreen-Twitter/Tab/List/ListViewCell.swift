//
//  ListViewCell.swift
//  SplashScreen-Twitter
//
//  Created by YIM SEKNY on 25/5/22.
//

import UIKit

class ListViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

//        self.imageView.layer.masksToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .red
    }
    
    func setImage(image: UIImage) {
        self.imageView.image = image
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.backgroundColor = .lightGray
    }
}
