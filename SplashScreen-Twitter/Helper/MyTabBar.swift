//
//  MyTabBar.swift
//  SplashScreen-Twitter
//
//  Created by YIM SEKNY on 25/5/22.
//

import UIKit

@IBDesignable
class MyTabBar: UITabBar {
    let a: CGFloat = 1.5
    private var shapeLayer: CALayer?
    
    override func draw(_ rect: CGRect) {
        self.addShape()
    }
    
    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPathCircle()
        shapeLayer.strokeColor = UIColor.bgColor().cgColor
        shapeLayer.fillColor = UIColor.lightDark().cgColor
        shapeLayer.lineWidth = 1.0
        
        //The below 4 lines are for shadow above the bar. you can skip them if you do not want a shadow
        shapeLayer.shadowOffset = CGSize(width:0, height:0)
        shapeLayer.shadowRadius = 10
//        shapeLayer.shadowColor = UIColor.gray.cgColor
//        shapeLayer.shadowOpacity = 0.3

        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }
    
//    func createPath() -> CGPath {
//        let height: CGFloat = 44.0
//        let path = UIBezierPath()
//        let centerWidth = self.frame.width / 2
//        path.move(to: CGPoint(x: 0, y: 0)) // start top left
//        path.addLine(to: CGPoint(x: (centerWidth - height), y: 0)) // the beginning of the trough
//
//        path.addCurve(to: CGPoint(x: centerWidth, y: height),
//        controlPoint1: CGPoint(x: (centerWidth - 40), y: 0), controlPoint2: CGPoint(x: centerWidth - 45, y: height))
//
//        path.addCurve(to: CGPoint(x: (centerWidth + height), y: 0),
//        controlPoint1: CGPoint(x: centerWidth + 45, y: height), controlPoint2: CGPoint(x: (centerWidth + 40), y: 0))
//
//        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
//        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
//        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
//        path.close()
//
//        return path.cgPath
//    }
    
    func createPath() -> CGPath {
        let height: CGFloat = 37.0
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2
        path.move(to: CGPoint (x: 0, y: 0)) // start top left
        path.addLine(to: CGPoint(x: (centerWidth - height * 2), y: 0)) // the beginning of the trough
        // first curve down
        path.addCurve(to: CGPoint(x: centerWidth, y: height),
                      controlPoint1: CGPoint(x: (centerWidth - 30), y: 0),
                      controlPoint2: CGPoint (x: centerWidth - 35, y: height))
        // second curve up
        path.addCurve(to: CGPoint(x: (centerWidth + height * 2), y: 0),
                        controlPoint1: CGPoint(x: (centerWidth + 35), y: height),
                        controlPoint2: CGPoint (x: (centerWidth + 30) , y: 0))
        // complete the rect
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint (x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint (x: 0, y: self.frame.height))
        path.close()
        return path.cgPath
        
    }
    
    func createPathCircle() -> CGPath {

            let radius: CGFloat = 42.5
            let path = UIBezierPath()
            let centerWidth = self.frame.width / 2

            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: (centerWidth - radius * 2), y: 0))
            path.addArc(withCenter: CGPoint(x: centerWidth, y: 0), radius: radius, startAngle: CGFloat(180).degreesToRadians, endAngle: CGFloat(0).degreesToRadians, clockwise: false)
            path.addLine(to: CGPoint(x: self.frame.width, y: 0))
            path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
            path.addLine(to: CGPoint(x: 0, y: self.frame.height))
            path.close()
            return path.cgPath
        }
}

