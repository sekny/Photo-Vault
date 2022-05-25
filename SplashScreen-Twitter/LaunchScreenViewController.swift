//
//  LaunchScreenViewController.swift
//  SplashScreen-Twitter
//
//  Created by YIM SEKNY on 23/5/22.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    var logoIsHidden: Bool = false
    static let logoImageBig: UIImage = UIImage(named: "TwitterLogoBig")!

    override func viewDidLoad() {
        super.viewDidLoad()

        logoImageView.isHidden = logoIsHidden
    }
    
    

}
