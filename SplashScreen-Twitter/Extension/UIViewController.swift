//
//  UIViewController.swift
//  SplashScreen-Twitter
//
//  Created by YIM SEKNY on 23/5/22.
//

import UIKit
extension  UIViewController {
    static func instantiateVC(storyboardName: String)-> Self {
          let mainStoryboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
          let fullName = NSStringFromClass(self)
          let className = fullName.components(separatedBy: ".")[1]
          let vc = mainStoryboard.instantiateViewController(withIdentifier: className) as! Self
          return vc
    }
}

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
