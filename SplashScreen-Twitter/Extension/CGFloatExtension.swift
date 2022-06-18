//
//  CGFloatExtension.swift
//  SplashScreen-Twitter
//
//  Created by YIM SEKNY on 8/6/22.
//

import UIKit

extension CGFloat {
    var degreesToRadians: CGFloat { return self * .pi / 180 }
    var radiansToDegrees: CGFloat { return self * 180 / .pi }
}
