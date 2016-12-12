//
//  GenerateAlert.swift
//  MyBus
//
//  Created by Julieta Gonzalez Poume on 8/11/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import UIKit

class GenerateMessageAlert
{
    class func generateAlert(viewController: UIViewController?, title: String, message: String){
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        let viewControllerToDisplay = (viewController != nil) ? viewController! : UIApplication.sharedApplication().keyWindow?.rootViewController!
        alert.addAction(action)
        viewControllerToDisplay!.presentViewController(alert, animated: true, completion: nil)
    }
    
    class func generateAlertToSetting(viewController: UIViewController){
        
        let alertController = UIAlertController (title: "Localización desactivada", message: "Para activar la localización: \n \n \n \n \n", preferredStyle: .Alert)
        
        let x = alertController.view.frame.origin.x
        let y = alertController.view.frame.origin.y
        alertController.view.frame=CGRectMake(x, y, alertController.view.frame.width, alertController.view.frame.height*0.25)
        
        let stepsView = loadFromNibNamed("StepActivateLocate")
        stepsView!.frame=CGRectMake(x+25, y+65, (stepsView?.frame.width)!, (stepsView?.frame.height)!)
        alertController.view.addSubview(stepsView!)
        
        let settingsAction = UIAlertAction(title: "Configuración", style: .Default) { (_) -> Void in
            let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
            if let url = settingsUrl {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        alertController.addAction(settingsAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .Default, handler: nil)
        alertController.addAction(cancelAction)
        
        viewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    class func loadFromNibNamed(nibNamed: String, bundle: NSBundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
}