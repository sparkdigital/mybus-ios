//
//  BusesInformationViewController.swift
//  MyBus
//
//  Created by Julieta Gonzalez Poume on 9/9/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//
import UIKit
import RealmSwift

class BusesInformationViewController: UIViewController, UITableViewDelegate
{
    
    var busesInformationDataSource: BusesInformationDataSource!
 
    @IBOutlet weak var informationTableView: UITableView!
    
    override func viewDidLoad()
    {
        self.busesInformationDataSource = BusesInformationDataSource()
        self.informationTableView.delegate = self
        self.informationTableView.dataSource = busesInformationDataSource
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}