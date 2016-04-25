//
//  SearchViewController.swift
//  MyBus
//
//  Created by Marcos Vivar on 4/13/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit
import Mapbox
import RealmSwift

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    @IBOutlet var resultsTableView: UITableView!
    @IBOutlet var originTextfield: UITextField!
    @IBOutlet var destinationTextfield: UITextField!
    
    var bestMatches : [String] = []
    var favourites : List<Location>!
    
    @IBOutlet var favoriteOriginButton: UIButton!
    @IBOutlet var favoriteDestinationButton: UIButton!
    
    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.originTextfield.addTarget(self, action: #selector(SearchViewController.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        self.destinationTextfield.addTarget(self, action: #selector(SearchViewController.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
    }
    
    override func viewDidAppear(animated: Bool)
    {
        // Create realm pointing to default file
        let realm = try! Realm()
        // Retrive favs locations for user
        favourites = realm.objects(User).first?.favourites
        self.resultsTableView.reloadData()
    }
    
    // MARK: - IBAction Methods
    
    @IBAction func favoriteOriginTapped(sender: AnyObject)
    {}
    
    @IBAction func favoriteDestinationTapped(sender: AnyObject)
    {}
    
    @IBAction func searchButtonTapped(sender: AnyObject)
    {
        Connectivity.sharedInstance.getBusLinesFromOriginDestination(-38.0184963929001, longitudeOrigin: -57.5284607195163, latitudeDestination: -38.0284822413709, longitudeDestination: -57.56271741574) { responseObject, error in
            print(responseObject)
            //TODO
        }
    }
    
    @IBAction func invertButton(sender: AnyObject)
    {
        let originText = self.originTextfield.text
        self.originTextfield.text = self.destinationTextfield.text
        self.destinationTextfield.text = originText
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        switch indexPath.section
        {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("FavoritesIdentifier", forIndexPath: indexPath) as UITableViewCell
            return buildFavCell(indexPath, cell: cell)
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("BestMatchesIdentifier", forIndexPath: indexPath) as! BestMatchTableViewCell
            cell.name.text = self.bestMatches[indexPath.row]
            return cell
            
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("BestMatchesIdentifier", forIndexPath: indexPath) as UITableViewCell
            
            return cell
        }
    }
    
    func buildFavCell(indexPath: NSIndexPath, cell : UITableViewCell) -> UITableViewCell
    {
        let fav = favourites[indexPath.row]
        let cellLabel : String
        let address = "\(fav.streetName) \(fav.houseNumber)"
        if(fav.name.isEmpty){
            cellLabel = address
        } else
        {
            cellLabel = fav.name
            cell.detailTextLabel?.text = address
        }
        cell.textLabel?.text = cellLabel
        return cell
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
            if let listFavs = favourites{
                return listFavs.count
            }
            return 0
        case 1:
            return bestMatches.count
            
        default:
            return bestMatches.count
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
    {
        let uiTextField = self.originTextfield.isFirstResponder() ? self.originTextfield : self.destinationTextfield
        switch indexPath.section
        {
        case 0:
            uiTextField.text = "\(favourites[indexPath.row].streetName) \(favourites[indexPath.row].houseNumber)"
        case 1:
            uiTextField.text = "\(bestMatches[indexPath.row]) "
            // Change & update keyboard type
            uiTextField.keyboardType = UIKeyboardType.NumberPad
            uiTextField.resignFirstResponder()
            uiTextField.becomeFirstResponder()
        default: break
        }
    }
    
    // MARK: - Textfields Methods
    
    func textFieldDidChange(sender: UITextField){
        if(sender.text?.characters.count > 2)
        {
            Connectivity.sharedInstance.getStreetNames(forName: sender.text!) { (streets, error) in
                if error == nil {
                    self.bestMatches = []
                    for street in streets! {
                        self.bestMatches.append(street.name)
                    }
                    self.resultsTableView.reloadData()
                }
            }
        } else if (sender.text?.characters.count == 0)
        {
            self.bestMatches = []
            self.resultsTableView.reloadData()
            self.originTextfield.keyboardType = UIKeyboardType.Alphabet
            self.originTextfield.resignFirstResponder()
            self.originTextfield.becomeFirstResponder()
        }
    }
    
    // MARK: - Memory Management Methods
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}