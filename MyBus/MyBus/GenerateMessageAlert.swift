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
    class func generateAlert(viewController: UIViewController, title: String, message: String){
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(action)
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
}