//
//  ScreenProtectionHelper.swift
//  SplashScreen-Twitter
//
//  Created by YIM SEKNY on 24/5/22.
//

import UIKit

class ScreenProtectionHelper {
    static let shared = ScreenProtectionHelper()
    
    // MARK: Privacy Protection
    private var privacyProtectionWindow: UIWindow?

    func showPrivacyProtectionWindow() {
        if #available(iOS 13.0, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                return
            }
            privacyProtectionWindow = UIWindow(windowScene: windowScene)
        } else {
            privacyProtectionWindow = UIWindow(frame: UIScreen.main.bounds)
        }

        let storyboard = UIStoryboard(name: Storyboards.Passcode.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: Storyboards.Passcode.rawValue)
        privacyProtectionWindow?.rootViewController = vc
        privacyProtectionWindow?.windowLevel = .alert + 1
        privacyProtectionWindow?.makeKeyAndVisible()
    }

    func hidePrivacyProtectionWindow() {
        privacyProtectionWindow?.isHidden = true
        privacyProtectionWindow = nil
    }
}
