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
    var faresActionClosure:(_ sender:AnyObject)->Void = { sender in
        sender.showBusFares(sender)
    }
    
    var termsActionClosure:(_ sender:AnyObject)->Void = { sender in
        sender.showTerms(sender)
    }
    
    var aboutActionClosure:(_ sender:AnyObject)->Void = { sender in
        sender.showAboutUs(sender)
    }
    
    @IBOutlet weak var moreTableView:UITableView!
    var moreDataset:[MoreSectionModel] = []
    let aboutUsAlertController = UIAlertController (title: "", message: "\n \n \n \n \n \n \n \n \n \n \n \n \n \n", preferredStyle: .alert)
    
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
        
        self.moreTableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension MoreViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let model:MoreSectionModel = moreDataset[indexPath.row] {
            model.executeAction(self)
        }
    }
    
}

extension MoreViewController:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moreDataset.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier:String = "MoreCell"
        
        guard let cell:MoreTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MoreTableViewCell else {
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
    func showBusFares(_ sender:AnyObject){
        LoggingManager.sharedInstance.logSection(LoggableAppSection.FARES)
        let busesRatesViewController = NavRouter().busesRatesController()
        sender.navigationController??.pushViewController(busesRatesViewController, animated: true)        
    }
}

//Terms and Conditions
extension MoreViewController {
    func showTerms(_ sender:AnyObject){
        LoggingManager.sharedInstance.logSection(LoggableAppSection.TERMS)
        let termsViewController = NavRouter().termsViewController()
        let navTermsViewController: UINavigationController = UINavigationController(rootViewController: termsViewController)
        
        if let vc = sender as? UIViewController {
            vc.applyTransitionAnimation(withDuration: 0.4, transitionType: TransitionType.moveIn, transitionSubType: TransitionSubtype.fromBottom)
        }
        
        sender.present(navTermsViewController, animated: false, completion: nil)
        
    }
}

// About Us
extension MoreViewController {
    
    func showAboutUs(_ sender:AnyObject){
        
        LoggingManager.sharedInstance.logSection(LoggableAppSection.ABOUT)
        
        let x = aboutUsAlertController.view.frame.origin.x
        let y = aboutUsAlertController.view.frame.origin.y
        
        let stepsView = UINib(nibName: "AboutUs", bundle: nil).instantiate(withOwner: sender, options: nil)[0] as!
        UIView
        aboutUsAlertController.view.frame=CGRect(x: x, y: y, width: stepsView.frame.width, height: 265)
        aboutUsAlertController.view.addSubview(stepsView)
        
        if let vc = sender as? UIViewController {
            vc.applyTransitionAnimation(withDuration: 0.6, transitionType: TransitionType.fade, transitionSubType: nil)
        }
        
        sender.present(aboutUsAlertController, animated: false, completion: nil)
    }
    
    @IBAction func dismissAboutUs(_ sender: AnyObject) {        
        aboutUsAlertController.applyTransitionAnimation(withDuration: 0.6, transitionType: TransitionType.fade, transitionSubType: nil)
        aboutUsAlertController.dismiss(animated: false, completion: nil)
    }
    
}
