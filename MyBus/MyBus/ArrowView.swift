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
    @IBInspectable var arrowColor:UIColor = UIColor.orange {
        didSet{
            layoutSubviews()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = UIColor.clear
        
        let midHeight:CGFloat = self.bounds.size.height / 2
        let midWidth:CGFloat = self.bounds.width / 2
        let fillPath:UIBezierPath = UIBezierPath()
        
        fillPath.move(to: CGPoint(x: 0, y: midHeight))
        fillPath.addLine(to: CGPoint(x: midWidth, y: 0))
        fillPath.addLine(to: CGPoint(x: self.bounds.width, y: midHeight))
        fillPath.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height))
        fillPath.addLine(to: CGPoint(x: midWidth, y: midHeight))
        fillPath.addLine(to: CGPoint(x: 0, y: self.bounds.height))
        fillPath.close()
        
        bezierArrowLayer = CAShapeLayer()
        bezierArrowLayer.frame = self.bounds
        bezierArrowLayer.path = fillPath.cgPath
        bezierArrowLayer.fillColor = arrowColor.cgColor
        
        layer.addSublayer(bezierArrowLayer)        
    }
    
}
