//
//  FavoriteViewController.swift
//  MyBus
//
//  Created by Julieta Gonzalez Poume on 10/11/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit
import RealmSwift
import DZNEmptyDataSet

class FavoriteViewController: UIViewController, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
{

    var favoriteDataSource: FavoriteDataSource!

    @IBOutlet weak var favoriteTableView: UITableView!

    override func viewDidLoad()
    {
        self.favoriteDataSource = FavoriteDataSource()
        self.favoriteTableView.delegate = self
        self.favoriteTableView.dataSource = favoriteDataSource

        self.favoriteTableView.emptyDataSetSource = self
        self.favoriteTableView.emptyDataSetDelegate = self
        // A little trick for removing the cell separators
        self.favoriteTableView.tableFooterView = UIView()
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
            let alert = UIAlertController(title: Localization.getLocalizedString("Eliminando"), message: Localization.getLocalizedString("Esta_seguro"), preferredStyle: UIAlertControllerStyle.ActionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (_) -> Void in
                self.favoriteDataSource.removeFavorite(indexPath)
                self.favoriteTableView.reloadData()})
            alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Cancel) { (_) -> Void in
                self.favoriteTableView.setEditing(false, animated: true)})
            self.presentViewController(alert, animated: true, completion: nil)
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
        let alert = UIAlertController(title: Localization.getLocalizedString("Agregando"), message: Localization.getLocalizedString("Nuevo_Favorito_Mensaje"), preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler({ (textField) in textField.placeholder = "Nombre" })
        alert.addTextFieldWithConfigurationHandler({ (textField) in textField.placeholder = "Calle" })
        alert.addTextFieldWithConfigurationHandler({ (textField) in textField.placeholder = "Altura" })

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (_) -> Void in
            guard let textFields = alert.textFields else {
                return
            }
            guard let name = textFields[0].text, let streetName = textFields[1].text, let houseNumber = textFields[2].text else {
                GenerateMessageAlert.generateAlert(self, title: Localization.getLocalizedString("No_Sabemos_Que"), message: Localization.getLocalizedString("Nuevo_Favorito_Error"))
                return
            }

            if (!name.isEmpty && !streetName.isEmpty && !houseNumber.isEmpty){
                ProgressHUD().showLoadingNotification(self.view)
                //Added blank between street name and house number
                let address = "\(streetName.lowercaseString) \(houseNumber.lowercaseString)"
                Connectivity.sharedInstance.getCoordinateFromAddress(address, completionHandler: { (point, error) in
                    ProgressHUD().stopLoadingNotification(self.view)
                    if let p = point {
                        p.name = name
                        self.favoriteDataSource.addFavorite(p)
                        self.favoriteTableView.reloadData()
                    }else{
                        GenerateMessageAlert.generateAlert(self, title: Localization.getLocalizedString(String.localizedStringWithFormat(NSLocalizedString("No_Sabemos", comment: "No_Sabemos"), "lugar")), message: "No pudimos resolver la dirección de \(streetName+" "+houseNumber) ingresada")
                    }})
            }else {
                GenerateMessageAlert.generateAlert(self, title: Localization.getLocalizedString("No_Sabemos_Que"), message: Localization.getLocalizedString("Nuevo_Favorito_Error"))
            }})

        alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    //MARK: DZNEmptyDataSet setup methods

    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: Localization.getLocalizedString("No_favoritos_Titulo"))
    }

    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes: [String : AnyObject] = [
            NSForegroundColorAttributeName: UIColor.lightGrayColor()
        ]
        return NSAttributedString(string: Localization.getLocalizedString("No_favoritos_Mensaje"), attributes: attributes)
    }

    func emptyDataSetShouldDisplay(scrollView: UIScrollView!) -> Bool {
        return true
    }

    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "empty_fav")
    }

}
