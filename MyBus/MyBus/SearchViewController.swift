//
//  SearchViewController.swift
//  MyBus
//
//  Created by Marcos Vivar on 4/13/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit
import Mapbox

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    @IBOutlet var resultsTableView: UITableView!
    
    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        switch indexPath.section
        {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("FavoritesIdentifier", forIndexPath: indexPath) as UITableViewCell
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("BestMatchesIdentifier", forIndexPath: indexPath) as UITableViewCell
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("BestMatchesIdentifier", forIndexPath: indexPath) as UITableViewCell
            
            return cell
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch section
        {
        case 0:
            return 5
        case 1:
            return 10
            
        default:
            return 10
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        switch section
        {
        case 0:
            return "Favorites"
        case 1:
            return "Best Matches"
            
        default:
            return "Best Matches"
        }
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {}
    
    // MARK: - Memory Management Methods
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}