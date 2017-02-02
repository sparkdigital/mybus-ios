//
//  FavoriteTableViewCell.swift
//  MyBus
//
//  Created by Julieta Gonzalez Poume on 9/15/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell, UITextFieldDelegate {

    var favorite: RoutePoint?
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var address: UITextField!

    func loadItem(_ favorite: RoutePoint) {
        self.favorite = favorite
        setUpFields()
    }

    func setUpFields() {
        guard let fav = self.favorite else {
            return
        }
        self.name.text = fav.name
        self.address.text = fav.address
        self.name.isUserInteractionEnabled = false
        self.address.isUserInteractionEnabled = false
        self.address.delegate = self
        self.name.delegate = self
    }

    func editCell() {
        self.name.isUserInteractionEnabled = true
        self.name.becomeFirstResponder()
        self.address.isUserInteractionEnabled = true
    }

    func editFav() {
        self.address.isUserInteractionEnabled = false
        self.name.isUserInteractionEnabled = false
        if let fav = favorite, let newAddress = self.address.text, let newName = self.name.text, (newAddress != fav.address || newName != fav.name) {
            ProgressHUD().showLoadingNotification(nil)
            if newAddress != fav.address {
                Connectivity.sharedInstance.getCoordinateFromAddress(newAddress, completionHandler: { (point, error) in
                    if let newFav = point, self.addressDoesNotAlreadyExist(newFav) {
                        self.address.text = newFav.address
                        DBManager.sharedInstance.updateFavorite(fav, name: newName, newFavLocation: newFav)
                    } else {
                        GenerateMessageAlert.generateAlert(nil, title: "Malas noticias ", message: "Lamentablemente no hemos podido localizar la dirección ingresada o ya existe un favorito con esa dirección")
                        self.address.text = fav.address
                        DBManager.sharedInstance.updateFavorite(fav, name: newName, newFavLocation: nil)
                        LoggingManager.sharedInstance.logEvent(LoggableAppEvent.FAVORITE_EDIT_LIST)
                    }
                    ProgressHUD().stopLoadingNotification(nil)
                })
            } else if newName != fav.name {
                DBManager.sharedInstance.updateFavorite(fav, name: newName, newFavLocation: nil)
                LoggingManager.sharedInstance.logEvent(LoggableAppEvent.FAVORITE_EDIT_LIST)
                ProgressHUD().stopLoadingNotification(nil)
            }

        }
    }

    func addressDoesNotAlreadyExist(_ newFav: RoutePoint) -> Bool {
        guard let favorites = DBManager.sharedInstance.getFavourites() else {
            return false
        }
        return favorites.filter({ (fav) -> Bool in
            return ((fav.latitude == newFav.latitude && fav.longitude == newFav.longitude) || fav.address == newFav.address)
        }).count == 0
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (self.name == textField){
            self.address.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            self.editFav()
        }
        return true
    }

}
