//
//  SearchSuggestionsViewController.swift
//  MyBus
//
//  Created by Sebastian Fink on 9/26/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit

class SearchSuggestionsViewController: UIViewController {

    @IBOutlet weak var suggestionsTableView: UITableView!
    
    let sampleSearches:[String] = ["a","b","c","d","e","f"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        suggestionsTableView.delegate = self
        suggestionsTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
}

// MARK: UITableViewDataSource protocol methods
extension SearchSuggestionsViewController:UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sampleSearches.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = "suggestionCell"
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = sampleSearches[indexPath.row]
        return cell
    }
}

// MARK: UITableViewDelegate protocol methods
extension SearchSuggestionsViewController:UITableViewDelegate{
    
}
