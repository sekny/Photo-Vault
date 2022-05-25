//
//  UIViewExtension.swift
//  SplashScreen-Twitter
//
//  Created by YIM SEKNY on 23/5/22.
//

import UIKit
import AudioToolbox

extension UIView {
    func shake(count : Float = 2,for duration : TimeInterval = 0.15,withTranslation translation : Float = 5,isVibrate: Bool = false) {

        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.repeatCount = count
        animation.duration = duration/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.values = [translation, -translation]
        layer.add(animation, forKey: "shake")
       
        if isVibrate {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
       
    }
}
