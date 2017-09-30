//
//  BusesRatesViewController.swift
//  MyBus
//
//  Created by Julieta Gonzalez Poume on 9/5/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit
import RealmSwift

class BusesRatesViewController: UIViewController, UITableViewDelegate
{

    var busesRatesDataSource: BusesRatesDataSource!

    @IBOutlet weak var ratesTableView: UITableView!
    override func viewDidLoad()
    {
        self.busesRatesDataSource = BusesRatesDataSource()
        self.ratesTableView.delegate = self
        self.ratesTableView.dataSource = busesRatesDataSource


        let backButton = UIBarButtonItem(title: " ", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backTapped) )
        backButton.image = UIImage(named:"arrow_back")
        backButton.tintColor = UIColor.white

        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.title = Localization.getLocalizedString("Tarifas")
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}

    @objc func backTapped(){
        let _ = self.navigationController?.popViewController(animated: true)
    }

}
