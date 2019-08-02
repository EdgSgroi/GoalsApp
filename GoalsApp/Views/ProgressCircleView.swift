//
//  ProgressCircleView.swift
//  GoalsApp
//
//  Created by Edgar Sgroi on 17/07/19.
//  Copyright © 2019 Edgar Sgroi. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class ProgressCircleView : UIView {
    
    @IBInspectable
    var progressValue:CGFloat = 0.50 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var circleWidth:CGFloat = 10.0 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var circleColor:UIColor = UIColor.gray {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var progressColor:UIColor = UIColor.blue {
        didSet{
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let fullCircle = CGFloat(2.0 * Double.pi)
        
        let start:CGFloat = -0.25 * fullCircle
        
        let progressEnd:CGFloat = progressValue * fullCircle + start
        
        let centerPoint = CGPoint(x: rect.midX, y: rect.midY)
        
        var radius:CGFloat = 0.0
        
        if rect.width < rect.height {
            radius = (rect.width - circleWidth) / 2.0
        }else{
            radius = (rect.height - circleWidth) / 2.0
        }
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setLineWidth(circleWidth)
        context?.setLineCap(CGLineCap.round)
        
        context?.setStrokeColor(self.circleColor.cgColor)
        context?.addArc(center: centerPoint, radius: radius, startAngle: 0, endAngle: fullCircle, clockwise: false)
        context?.strokePath()
        
        context?.setStrokeColor(progressColor.cgColor)
        context?.addArc(center: centerPoint, radius: radius, startAngle: start, endAngle: progressEnd, clockwise: false)
        context?.strokePath()
    }

}
