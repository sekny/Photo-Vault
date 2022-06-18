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
    
    func blur() {
//        // Init a UIVisualEffectView which going to do the blur for us
//        let blurView = UIVisualEffectView()
//        // Make its frame equal the main view frame so that every pixel is under blurred
//        blurView.frame = self.frame
//        // Choose the style of the blur effect to regular.
//        // You can choose dark, light, or extraLight if you wants
//        blurView.effect = UIBlurEffect(style: style)
//        // Now add the blur view to the main view
//        self.addSubview(blurView)
        
        
        let blur = UIBlurEffect(style: .extraLight)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.layer.opacity = 0.2
        self.addSubview(blurView)
    }
}
