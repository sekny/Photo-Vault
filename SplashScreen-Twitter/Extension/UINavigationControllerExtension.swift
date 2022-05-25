//
//  UINavigationControllerExtension.swift
//  SplashScreen-Twitter
//
//  Created by YIM SEKNY on 24/5/22.
//

import UIKit
extension UINavigationController {
    
    ///Get previous view controller of the navigation stack
    func previousViewController() -> UIViewController?{
        
        let lenght = self.viewControllers.count
        
        let previousViewController: UIViewController? = lenght >= 2 ? self.viewControllers[lenght-2] : nil
        
        return previousViewController
    }
    
}
