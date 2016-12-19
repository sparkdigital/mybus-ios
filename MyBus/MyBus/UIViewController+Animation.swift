//
//  UIViewController+Animation.swift
//  MyBus
//
//  Created by Sebastian Fink on 12/19/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    enum TransitionType {
        case Fade, MoveIn, Push, Reveal
        
        func localizedDescription() -> String {
            switch self {
            case .Fade:
                return kCATransitionFade
            case .MoveIn:
                return kCATransitionMoveIn
            case .Push:
                return kCATransitionPush
            case .Reveal:
                return kCATransitionReveal
            }
        }
    }
    
    enum TransitionSubtype {
        case FromLeft, FromRight, FromTop, FromBottom
        
        func localizedDescription() -> String {
            switch self {
            case .FromBottom:
                return kCATransitionFromBottom
            case .FromTop:
                return kCATransitionFromTop
            case .FromLeft:
                return kCATransitionFromLeft
            case .FromRight:
                return kCATransitionFromRight
            }
        }
    }
    
    
    
    func applyTransitionAnimation(withDuration duration:CFTimeInterval, transitionType:TransitionType, transitionSubType:TransitionSubtype?) -> Bool{
        
        if let target = self.view.window {
            
            let transition = CATransition()
            transition.duration = duration
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            transition.type = transitionType.localizedDescription()
            transition.subtype = transitionSubType?.localizedDescription()
            target.layer.addAnimation(transition, forKey: kCATransition)
            return true
            
        }
        
        return false
        
    }
}
