//
//  FavoriteViewController.swift
//  MyBus
//
//  Created by Julieta Gonzalez Poume on 10/11/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit
import RealmSwift

class FavoriteViewController: UIViewController, UITableViewDelegate
{

    var favoriteDataSource: FavoriteDataSource!

    @IBOutlet weak var favoriteTableView: UITableView!

    override func viewDidLoad()
    {
        self.favoriteDataSource = FavoriteDataSource()
        self.favoriteTableView.delegate = self
        self.favoriteTableView.dataSource = favoriteDataSource
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.favoriteDataSource.loadFav()
        self.favoriteTableView.reloadData()
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }


    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Borrar") { (action, indexPath ) -> Void in
            self.editing = false
            self.favoriteDataSource.removeFavorite(indexPath)
            self.favoriteTableView.reloadData()
        }

        let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Editar") { (action, indexPath ) -> Void in
            let cell: FavoriteTableViewCell = self.favoriteTableView.cellForRowAtIndexPath(indexPath) as! FavoriteTableViewCell
            cell.editCell()
            self.favoriteTableView.setEditing(false, animated: true)
        }
        editAction.backgroundColor = UIColor(hexString: "0288D1")
        return [deleteAction, editAction]
    }
    
    func addFavoritePlace() {
        let alert = UIAlertController(title: "Nuevo lugar favorito", message: "Por favor ingresa los datos necesarios para el lugar Favorito", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler({ (textField) in textField.placeholder = "Nombre" })
        alert.addTextFieldWithConfigurationHandler({ (textField) in textField.placeholder = "Calle" })
        alert.addTextFieldWithConfigurationHandler({ (textField) in textField.placeholder = "Altura" })
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (_) -> Void in
            let name = alert.textFields![0].text!
            let streetName = alert.textFields![1].text!
            let houseNumber = alert.textFields![2].text!

            if (!name.isEmpty && !streetName.isEmpty && !houseNumber.isEmpty){
                Connectivity.sharedInstance.getCoordinateFromAddress(streetName.lowercaseString+houseNumber.lowercaseString, completionHandler: { (point, error) in
                    if let p = point {
                        p.name = name
                        self.favoriteDataSource.addFavorite(p)
                        self.favoriteTableView.reloadData()
                    }else{
                        GenerateMessageAlert.generateAlert(self, title: "No encontramos la ubicacion en el mapa", message: "No pudimos resolver la dirección de \(streetName+" "+houseNumber) ingresada")
                    }})
            }else {
                GenerateMessageAlert.generateAlert(self, title: "No sabemos que buscar", message: "Nos encontramos que un dato no esta indicado, por favor completa todos los campos")
            }})
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
