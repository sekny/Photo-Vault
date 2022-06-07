//
//  SettingCell.swift
//  SplashScreen-Twitter
//
//  Created by YIM SEKNY on 31/5/22.
//

import UIKit

class SettingCell: UITableViewCell {

    @IBOutlet weak var letLogo: UIImageView!
    @IBOutlet weak var rightIcon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var borderBottomView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()

        borderBottomView.clipsToBounds = true
        borderBottomView.layer.cornerRadius = 0.5
        borderBottomView.backgroundColor = UIColor.textColor().withAlphaComponent(0.5)
        self.backgroundColor = UIColor.lightDark()
        self.contentView.backgroundColor = UIColor.lightDark()
        self.letLogo.tintColor = UIColor.textColor()
        self.rightIcon.tintColor = UIColor.textColor()
        self.title.textColor = UIColor.textColor()
    }
    
    
    func setup(_ item: SettingModel) {
        title.text = item.title
        
        letLogo.image = UIImage(systemName: item.icon.isEmpty ? "arrow.forward.circle" : item.icon)
        
        rightIcon.image = UIImage(systemName: item.rightIcon.isEmpty ? "chevron.right" : item.rightIcon)
    }
}
