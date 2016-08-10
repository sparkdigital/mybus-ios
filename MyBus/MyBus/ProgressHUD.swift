//
//  ProgressHUD.swift
//  MyBus
//
//  Created by Julieta Gonzalez Poume on 8/10/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import MBProgressHUD


class ProgressHUD
{
    func showLoadingNotification(view:UIView)
    {
        let loadingNotification = MBProgressHUD.showHUDAddedTo(view, animated:true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Cargando"
    }
    
    func stopLoadingNotification(view:UIView)
    {
        MBProgressHUD.hideAllHUDsForView(view,animated: true)
    }
}