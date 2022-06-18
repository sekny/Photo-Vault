//
//  AboutViewController.swift
//  SplashScreen-Twitter
//
//  Created by YIM SEKNY on 3/6/22.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var scrollViewcontainer: UIScrollView!
    @IBOutlet weak var viewCenterStackcontainer: UIView!
    @IBOutlet weak var viewBody: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imgHeader: UIImageView!
    @IBOutlet weak var imageProfile: UIImageView!
    
    @IBOutlet weak var viewFollow: UIView!
    @IBOutlet weak var viewTwitter: UIView!
    @IBOutlet weak var viewTelegram: UIView!
    let radius: CGFloat = 20
    let borderWidth: CGFloat = 1.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        self.view.backgroundColor = UIColor.bgColor()
        self.viewContainer.backgroundColor = .clear
        
        self.viewHeader.backgroundColor = .clear
        viewHeader.layer.shadowColor = UIColor.shadow().cgColor
        viewHeader.layer.shadowOffset = CGSize(width: 3, height: 3)
        viewHeader.layer.shadowOpacity = 0.5
        viewHeader.layer.shadowRadius = radius
        
        self.viewBody.backgroundColor = .clear
        
        imgHeader.contentMode = .scaleToFill
//        imgHeader.frame.size.height = imgHeader.frame.size.width
        imgHeader.center = self.view.center
        imgHeader.layer.cornerRadius = radius
        imgHeader.clipsToBounds = true
        
        imageProfile.layer.borderColor = UIColor.white.cgColor
        imageProfile.layer.borderWidth = borderWidth
        imageProfile.layer.cornerRadius = imageProfile.layer.frame.width / 2
        imageProfile.clipsToBounds = true
        
        viewCenterStackcontainer.layer.cornerRadius = radius
        viewCenterStackcontainer.clipsToBounds = true
        viewCenterStackcontainer.backgroundColor = UIColor.primaryDark()
        viewCenterStackcontainer.layer.borderWidth = borderWidth
        viewCenterStackcontainer.layer.borderColor = UIColor.primaryDark().cgColor
        viewCenterStackcontainer.layer.opacity = 0.95
        
        
        let tapFollow = UITapGestureRecognizer(target: self, action: #selector(self.handleTapFollow(_:)))
        viewFollow.addGestureRecognizer(tapFollow)
        viewFollow.isUserInteractionEnabled = true
        viewFollow.backgroundColor = .clear
        viewFollow.layer.borderWidth = borderWidth
        viewFollow.layer.borderColor = UIColor.white.cgColor
        viewFollow.layer.cornerRadius = viewFollow.frame.height / 2
        viewFollow.clipsToBounds = true
        viewFollow.blur()
        
        
        let tapTwitter = UITapGestureRecognizer(target: self, action: #selector(self.handleTapTwitter(_:)))
        viewTwitter.addGestureRecognizer(tapTwitter)
        viewTwitter.isUserInteractionEnabled = true
        viewTwitter.layer.borderColor = UIColor.white.cgColor
        viewTwitter.backgroundColor = .clear
        viewTwitter.layer.borderWidth = borderWidth
        viewTwitter.layer.cornerRadius = viewTwitter.frame.height / 2
        viewTwitter.clipsToBounds = true
        viewTwitter.blur()
        
        
        let tapTelegram = UITapGestureRecognizer(target: self, action: #selector(self.handleTapTelegram(_:)))
        viewTelegram.addGestureRecognizer(tapTelegram)
        viewTelegram.isUserInteractionEnabled = true
        viewTelegram.layer.borderColor = UIColor.white.cgColor
        viewTelegram.backgroundColor = .clear
        viewTelegram.layer.borderWidth = borderWidth
        viewTelegram.layer.cornerRadius = viewTelegram.frame.height / 2
        viewTelegram.clipsToBounds = true
        viewTelegram.blur()
        
        
    }
    
    @objc func handleTapFollow(_ sender: UITapGestureRecognizer? = nil) {
        print("handleTapViewFollow")
    }
    
    @objc func handleTapTwitter(_ sender: UITapGestureRecognizer? = nil) {
        print("handleTapViewTwitter")
    }
    
    @objc func handleTapTelegram(_ sender: UITapGestureRecognizer? = nil) {
        print("handleTapViewTelegram")
    }
}
