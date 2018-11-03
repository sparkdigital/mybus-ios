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
    class func generateAlert(_ viewController: UIViewController?, title: String, message: String){
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        let viewControllerToDisplay = (viewController != nil) ? viewController! : UIApplication.shared.keyWindow?.rootViewController!
        alert.addAction(action)
        viewControllerToDisplay!.present(alert, animated: true, completion: nil)
    }

    class func generateAlertToSetting(_ viewController: UIViewController){

        let alertController = UIAlertController (title: "Localización desactivada", message: "Para activar la localización: \n \n \n \n \n", preferredStyle: .alert)

        let x = alertController.view.frame.origin.x
        let y = alertController.view.frame.origin.y
        alertController.view.frame=CGRect(x: x, y: y, width: alertController.view.frame.width, height: alertController.view.frame.height*0.25)

        let stepsView = loadFromNibNamed("StepActivateLocate")
        stepsView!.frame=CGRect(x: x+25, y: y+65, width: (stepsView?.frame.width)!, height: (stepsView?.frame.height)!)
        alertController.view.addSubview(stepsView!)

        let settingsAction = UIAlertAction(title: "Configuración", style: .default) { (_) -> Void in
            let settingsUrl = URL(string: UIApplication.openSettingsURLString)
            if let url = settingsUrl {
                UIApplication.shared.openURL(url)
            }
        }
        alertController.addAction(settingsAction)

        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        alertController.addAction(cancelAction)

        viewController.present(alertController, animated: true, completion: nil)
    }

    class func loadFromNibNamed(_ nibNamed: String, bundle: Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
}
