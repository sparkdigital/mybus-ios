//
//  ProgressHUD.swift
//  MyBus
//
//  Created by Julieta Gonzalez Poume on 8/10/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import MBProgressHUD


open class ProgressHUD
{
    func showLoadingNotification(_ view:UIView?)
    {
        let loadingNotification = MBProgressHUD.showAdded(to: (UIApplication.shared.keyWindow?.rootViewController!.view)!, animated:true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Cargando"
    }
    
    func stopLoadingNotification(_ view:UIView?)
    {
        MBProgressHUD.hideAllHUDs(for: (UIApplication.shared.keyWindow?.rootViewController!.view)!,animated: true)
    }
}
