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
    var roadResultList : [MapBusRoad] = []
    
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
        let originTextFieldValue = originTextfield.text!
        let destinationTextFieldValue = destinationTextfield.text!

        //TODO : Extract some pieces of code to clean and do async parallel
        Connectivity.sharedInstance.getCoordinateFromAddress(originTextFieldValue) {
            originGeocoded, error in
            
            let status = originGeocoded!["status"].stringValue
            switch status
            {
                case "OK":
                    let originLocation = originGeocoded!["results"][0]["geometry"]["location"]
                    let latitudeOrigin : Double = Double(originLocation["lat"].stringValue)!
                    let longitudeOrigin : Double = Double(originLocation["lng"].stringValue)!
                    Connectivity.sharedInstance.getCoordinateFromAddress(destinationTextFieldValue) {
                        destinationGeocoded, error in
                        
                        let status = destinationGeocoded!["status"].stringValue
                        switch status
                        {
                            case "OK":
                                let destinationLocation = destinationGeocoded!["results"][0]["geometry"]["location"]
                                let latitudeDestination : Double = Double(destinationLocation["lat"].stringValue)!
                                let longitudeDestination : Double = Double(destinationLocation["lng"].stringValue)!
                                self.getBusLines(latitudeOrigin, longitudeOrigin: longitudeOrigin, latDestination: latitudeDestination, lngDestination: longitudeDestination)
                            default:
                                //TODO Notify user about error
                                break
                        }
                    }
                default:
                    //TODO Notify user about error
                    break
                
            }
        }
    }
    
    func getBusLines(latitudeOrigin : Double, longitudeOrigin : Double, latDestination : Double, lngDestination : Double) -> Void {
        Connectivity.sharedInstance.getBusLinesFromOriginDestination(latitudeOrigin, longitudeOrigin: longitudeOrigin, latitudeDestination: latDestination, longitudeDestination: lngDestination) { busRouteResults, error in
            self.bestMatches = []
            for busRouteResult in busRouteResults! {
                var 🚌 : String = "🚍"
                for route in busRouteResult.busRoutes {
                    let busLineFormatted = route.busLineName!.characters.count == 3 ? route.busLineName!+"  " : route.busLineName!
                    🚌 = "\(🚌) \(busLineFormatted) ➡"
                }
                🚌.removeAtIndex(🚌.endIndex.predecessor())
                self.bestMatches.append(🚌)
            }
            self.resultsTableView.reloadData()
            self.getBusRoads(busRouteResults!)
        }
    }
    
    func getBusRoads(busRouteResults : [BusRouteResult]) -> Void {
        for busRouteResult in busRouteResults {
            if(busRouteResult.busRouteType == 0) //single road
            {
                Connectivity.sharedInstance.getSingleResultRoadApi((busRouteResult.busRoutes.first?.idBusLine)!, direction: (busRouteResult.busRoutes.first?.busLineDirection)!, stop1: (busRouteResult.busRoutes.first?.startBusStopNumber)!, stop2: (busRouteResult.busRoutes.first?.destinationBusStopNumber)!) {
                    singleRoad, error in
                    print("Single road")
                    self.roadResultList.append(MapBusRoad().addBusRoadOnMap(singleRoad!))
                    print(self.roadResultList.count)
                }
            } else if(busRouteResult.busRouteType == 1) { //combined road
                let firstBusRoute = busRouteResult.busRoutes.first
                let secondBusRoute = busRouteResult.busRoutes.last
                Connectivity.sharedInstance.getCombinedResultRoadApi((firstBusRoute?.idBusLine)!, idLine2: (secondBusRoute?.idBusLine)!, direction1: (firstBusRoute?.busLineDirection)!, direction2: (secondBusRoute?.busLineDirection)!, L1stop1: (firstBusRoute?.startBusStopNumber)!, L1stop2: (firstBusRoute?.destinationBusStopNumber)!, L2stop1: (secondBusRoute?.startBusStopNumber)!, L2stop2: (secondBusRoute?.destinationBusStopNumber)!){
                    combinedRoad, error in
                    print("Combinated road")
                    self.roadResultList.append(MapBusRoad().addBusRoadOnMap(combinedRoad!))
                }
            }
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