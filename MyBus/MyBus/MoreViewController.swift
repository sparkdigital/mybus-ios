//
//  MoreViewController.swift
//  MyBus
//
//  Created by Sebastian Fink on 12/16/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {
    
    //Closures
    var faresActionClosure:(sender:AnyObject)->Void = { sender in
        sender.showBusFares(sender)
    }
    
    var termsActionClosure:(sender:AnyObject)->Void = { sender in
        sender.showTerms(sender)
    }
    
    var aboutActionClosure:(sender:AnyObject)->Void = { sender in
        sender.showAboutUs(sender)
    }
    
    @IBOutlet weak var moreTableView:UITableView!
    var moreDataset:[MoreSectionModel] = []
    let aboutUsAlertController = UIAlertController (title: "", message: "\n \n \n \n \n \n \n \n \n \n \n \n \n \n", preferredStyle: .Alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.moreTableView.delegate = self
        self.moreTableView.dataSource = self
        
        //Build sections
        let faresModel:MoreSectionModel = MoreSectionModel(path: "pricetag", sectionName: "Tarifas", action: faresActionClosure)
        let termsModel:MoreSectionModel = MoreSectionModel(path: "terms", sectionName: "Terminos y Condiciones", action: termsActionClosure)
        let aboutModel:MoreSectionModel = MoreSectionModel(path: "about_us", sectionName: "Acerca de", action: aboutActionClosure)
        
        moreDataset.append(faresModel)
        moreDataset.append(termsModel)
        moreDataset.append(aboutModel)
        
        self.moreTableView.tableFooterView = UIView(frame: CGRectZero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension MoreViewController:UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let model:MoreSectionModel = moreDataset[indexPath.row] {
            model.executeAction(sender: self)
        }
    }
    
}

extension MoreViewController:UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moreDataset.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier:String = "MoreCell"
        
        guard let cell:MoreTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as? MoreTableViewCell else {
            return UITableViewCell()
        }
        
        if let model:MoreSectionModel = moreDataset[indexPath.row]{
            cell.moreModel = model
        }
        
        return cell
    }
    
}

//Bus Fares
extension MoreViewController {
    func showBusFares(sender:AnyObject){
        LoggingManager.sharedInstance.logSection(LoggableAppSection.FARES)
        let busesRatesViewController = NavRouter().busesRatesController()
        sender.navigationController??.pushViewController(busesRatesViewController, animated: true)        
    }
}

//Terms and Conditions
extension MoreViewController {
    func showTerms(sender:AnyObject){
        LoggingManager.sharedInstance.logSection(LoggableAppSection.TERMS)
        let termsViewController = NavRouter().termsViewController()
        let navTermsViewController: UINavigationController = UINavigationController(rootViewController: termsViewController)
        
        if let vc = sender as? UIViewController {
            vc.applyTransitionAnimation(withDuration: 0.4, transitionType: TransitionType.MoveIn, transitionSubType: TransitionSubtype.FromBottom)
        }
        
        sender.presentViewController(navTermsViewController, animated: false, completion: nil)
        
    }
}

// About Us
extension MoreViewController {
    
    func showAboutUs(sender:AnyObject){
        
        LoggingManager.sharedInstance.logSection(LoggableAppSection.ABOUT)
        
        let x = aboutUsAlertController.view.frame.origin.x
        let y = aboutUsAlertController.view.frame.origin.y
        
        let stepsView = UINib(nibName: "AboutUs", bundle: nil).instantiateWithOwner(sender, options: nil)[0] as!
        UIView
        aboutUsAlertController.view.frame=CGRectMake(x, y, stepsView.frame.width, 265)
        aboutUsAlertController.view.addSubview(stepsView)
        
        if let vc = sender as? UIViewController {
            vc.applyTransitionAnimation(withDuration: 0.6, transitionType: TransitionType.Fade, transitionSubType: nil)
        }
        
        sender.presentViewController(aboutUsAlertController, animated: false, completion: nil)
    }
    
    @IBAction func dismissAboutUs(sender: AnyObject) {        
        aboutUsAlertController.applyTransitionAnimation(withDuration: 0.6, transitionType: TransitionType.Fade, transitionSubType: nil)
        aboutUsAlertController.dismissViewControllerAnimated(false, completion: nil)
    }
    
}