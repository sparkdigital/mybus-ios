//
//  ArrowView.swift
//  MyBus
//
//  Created by Sebastian Fink on 12/13/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class ArrowView:UIView {
    
    var bezierArrowLayer:CAShapeLayer!
    @IBInspectable var arrowColor:UIColor = UIColor.orangeColor() {
        didSet{
            layoutSubviews()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = UIColor.clearColor()
        
        let midHeight:CGFloat = self.bounds.size.height / 2
        let midWidth:CGFloat = self.bounds.width / 2
        let fillPath:UIBezierPath = UIBezierPath()
        
        fillPath.moveToPoint(CGPointMake(0, midHeight))
        fillPath.addLineToPoint(CGPointMake(midWidth, 0))
        fillPath.addLineToPoint(CGPointMake(self.bounds.width, midHeight))
        fillPath.addLineToPoint(CGPointMake(self.bounds.width, self.bounds.height))
        fillPath.addLineToPoint(CGPointMake(midWidth, midHeight))
        fillPath.addLineToPoint(CGPointMake(0, self.bounds.height))
        fillPath.closePath()
        
        bezierArrowLayer = CAShapeLayer()
        bezierArrowLayer.frame = self.bounds
        bezierArrowLayer.path = fillPath.CGPath
        bezierArrowLayer.fillColor = arrowColor.CGColor
        
        layer.addSublayer(bezierArrowLayer)        
    }
    
}
