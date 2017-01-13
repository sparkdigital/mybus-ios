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
        case fade, moveIn, push, reveal
        
        func localizedDescription() -> String {
            switch self {
            case .fade:
                return kCATransitionFade
            case .moveIn:
                return kCATransitionMoveIn
            case .push:
                return kCATransitionPush
            case .reveal:
                return kCATransitionReveal
            }
        }
    }
    
    enum TransitionSubtype {
        case fromLeft, fromRight, fromTop, fromBottom
        
        func localizedDescription() -> String {
            switch self {
            case .fromBottom:
                return kCATransitionFromBottom
            case .fromTop:
                return kCATransitionFromTop
            case .fromLeft:
                return kCATransitionFromLeft
            case .fromRight:
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
            target.layer.add(transition, forKey: kCATransition)
            return true
            
        }
        
        return false
        
    }
}
