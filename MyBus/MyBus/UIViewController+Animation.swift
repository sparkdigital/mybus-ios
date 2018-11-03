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
                return convertFromCATransitionType(CATransitionType.fade)
            case .moveIn:
                return convertFromCATransitionType(CATransitionType.moveIn)
            case .push:
                return convertFromCATransitionType(CATransitionType.push)
            case .reveal:
                return convertFromCATransitionType(CATransitionType.reveal)
            }
        }
    }

    enum TransitionSubtype {
        case fromLeft, fromRight, fromTop, fromBottom

        func localizedDescription() -> String {
            switch self {
            case .fromBottom:
                return convertFromCATransitionSubtype(CATransitionSubtype.fromBottom)
            case .fromTop:
                return convertFromCATransitionSubtype(CATransitionSubtype.fromTop)
            case .fromLeft:
                return convertFromCATransitionSubtype(CATransitionSubtype.fromLeft)
            case .fromRight:
                return convertFromCATransitionSubtype(CATransitionSubtype.fromRight)
            }
        }
    }



    func applyTransitionAnimation(withDuration duration: CFTimeInterval, transitionType: TransitionType, transitionSubType: TransitionSubtype?) -> Bool{

        if let target = self.view.window {

            let transition = CATransition()
            transition.duration = duration
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            transition.type = convertToCATransitionType(transitionType.localizedDescription())
            transition.subtype = convertToOptionalCATransitionSubtype(transitionSubType?.localizedDescription())
            target.layer.add(transition, forKey: kCATransition)
            return true

        }

        return false

    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromCATransitionType(_ input: CATransitionType) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromCATransitionSubtype(_ input: CATransitionSubtype) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToCATransitionType(_ input: String) -> CATransitionType {
	return CATransitionType(rawValue: input)
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalCATransitionSubtype(_ input: String?) -> CATransitionSubtype? {
	guard let input = input else { return nil }
	return CATransitionSubtype(rawValue: input)
}
