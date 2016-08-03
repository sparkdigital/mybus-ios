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

protocol MapBusRoadDelegate {
    func newBusRoad(mapBusRoad: MapBusRoad)
    func newResults(busResults: [String], busResultsDetail: [BusRouteResult])
    func newOrigin(coordinate: CLLocationCoordinate2D, address: String)
    func newDestination(coordinate: CLLocationCoordinate2D, address: String)
}

class SearchViewController: UIViewController, UITableViewDelegate
{

    @IBOutlet var resultsTableView: UITableView!
    @IBOutlet var originTextfield: UITextField!
    @IBOutlet var destinationTextfield: UITextField!

    var searchViewProtocol: MapBusRoadDelegate?
    var busResults: [String] = []
    var bestMatches: [String] = []
    var favourites: List<Location>?
    var roadResultList: [MapBusRoad] = []

    var streetSuggestionsDataSource: SearchSuggestionsDataSource!

    // MARK: - View Lifecycle Methods

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.originTextfield.addTarget(self, action: #selector(SearchViewController.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        self.destinationTextfield.addTarget(self, action: #selector(SearchViewController.textFieldDidChange(_:)), forControlEvents: .EditingChanged)

        self.streetSuggestionsDataSource = SearchSuggestionsDataSource()

        self.resultsTableView.delegate = self
        self.resultsTableView.dataSource = streetSuggestionsDataSource
    }

    override func viewDidAppear(animated: Bool) {
        // Create realm pointing to default file
        let realm = try! Realm()
        // Retrive favs locations for user
        favourites = realm.objects(User).first?.favourites
        self.streetSuggestionsDataSource.favourites = favourites
        self.resultsTableView.reloadData()
    }

    // MARK: - IBAction Methods

    @IBAction func favoriteOriginTapped(sender: AnyObject) {}

    @IBAction func favoriteDestinationTapped(sender: AnyObject) {}

    @IBAction func searchButtonTapped(sender: AnyObject) {
        let originTextFieldValue = originTextfield.text!
        let destinationTextFieldValue = destinationTextfield.text!
        self.view.endEditing(true)

        //TODO : Extract some pieces of code to clean and do async parallel
        Connectivity.sharedInstance.getCoordinateFromAddress(originTextFieldValue) {
            originGeocoded, error in

            let status = originGeocoded!["status"].stringValue
            switch status {
                case "OK":
                    let firstResult = originGeocoded!["results"][0]
                    let isAddress = firstResult["address_components"][0]["types"] == [ "street_number" ]
                    guard isAddress else {
                        let alert = UIAlertController.init(title: "No sabemos donde es el origen", message: "No pudimos resolver la dirección de origen ingresada", preferredStyle: .Alert)
                        let action = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                        alert.addAction(action)
                        self.presentViewController(alert, animated: true, completion: nil)
                        break
                    }
                    let originLocation = firstResult["geometry"]["location"]
                    let latitudeOrigin: Double = Double(originLocation["lat"].stringValue)!
                    let longitudeOrigin: Double = Double(originLocation["lng"].stringValue)!
                    let streetName = firstResult["address_components"][1]["short_name"].stringValue
                    let streetNumber = firstResult["address_components"][0]["short_name"].stringValue
                    let address: String =  "\(streetName) \(streetNumber)"
                    self.searchViewProtocol?.newOrigin(CLLocationCoordinate2D(latitude: latitudeOrigin, longitude: longitudeOrigin), address: address)
                    Connectivity.sharedInstance.getCoordinateFromAddress(destinationTextFieldValue) {
                        destinationGeocoded, error in

                        let status = destinationGeocoded!["status"].stringValue
                        switch status {
                            case "OK":
                                let isAddress = destinationGeocoded!["results"][0]["address_components"][0]["types"] == [ "street_number" ]
                                guard isAddress else {
                                    let alert = UIAlertController.init(title: "No sabemos donde es el destino", message: "No pudimos resolver la dirección de destino ingresada", preferredStyle: .Alert)
                                    let action = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                                    alert.addAction(action)
                                    self.presentViewController(alert, animated: true, completion: nil)
                                    break
                                }
                                let destinationLocation = destinationGeocoded!["results"][0]["geometry"]["location"]
                                let latitudeDestination: Double = Double(destinationLocation["lat"].stringValue)!
                                let longitudeDestination: Double = Double(destinationLocation["lng"].stringValue)!

                                let streetName = destinationGeocoded!["results"][0]["address_components"][1]["short_name"].stringValue
                                let streetNumber = destinationGeocoded!["results"][0]["address_components"][0]["short_name"].stringValue
                                let address: String =  "\(streetName) \(streetNumber)"

                                self.searchViewProtocol?.newDestination(CLLocationCoordinate2D(latitude: latitudeDestination, longitude: longitudeDestination), address: address)

                                self.getBusLines(latitudeOrigin, longitudeOrigin: longitudeOrigin, latDestination: latitudeDestination, lngDestination: longitudeDestination)
                            default:
                                let alert = UIAlertController.init(title: "No sabemos donde es el destino", message: "No pudimos resolver la dirección de destino ingresada", preferredStyle: .Alert)
                                let action = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                                alert.addAction(action)
                                self.presentViewController(alert, animated: true, completion: nil)
                                break
                        }
                    }
                default:
                    let alert = UIAlertController.init(title: "No sabemos donde es el origen", message: "No pudimos resolver la dirección de origen ingresada", preferredStyle: .Alert)
                    let action = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                    break

            }
        }
    }

    func getBusLines(latitudeOrigin: Double, longitudeOrigin: Double, latDestination: Double, lngDestination: Double) -> Void {
        Connectivity.sharedInstance.getBusLinesFromOriginDestination(latitudeOrigin, longitudeOrigin: longitudeOrigin, latitudeDestination: latDestination, longitudeDestination: lngDestination) {
            busRouteResults, error in
            // Reset previous streets names or bus lines and road from a previous search
            self.busResults = []
            self.roadResultList = []
            for busRouteResult in busRouteResults! {
                var 🚌 : String = "🚍"
                for route in busRouteResult.busRoutes {
                    let busLineFormatted = route.busLineName!.characters.count == 3 ? route.busLineName!+"  " : route.busLineName!
                    🚌 = "\(🚌) \(busLineFormatted) ➡"
                }
                🚌.removeAtIndex(🚌.endIndex.predecessor())
                self.busResults.append(🚌)
            }
            self.searchViewProtocol?.newResults(self.busResults, busResultsDetail: busRouteResults!)
        }
    }

    @IBAction func invertButton(sender: AnyObject) {
        let originText = self.originTextfield.text
        self.originTextfield.text = self.destinationTextfield.text
        self.destinationTextfield.text = originText
    }

    // MARK: - UITableViewDelegate Methods

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let uiTextField = self.originTextfield.isFirstResponder() ? self.originTextfield : self.destinationTextfield
        switch indexPath.section {
        case 0:
            uiTextField.text = "\(favourites![indexPath.row].streetName) \(favourites![indexPath.row].houseNumber)"
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

    func textFieldDidChange(sender: UITextField) {
        if sender.text?.characters.count > 2 {
            Connectivity.sharedInstance.getStreetNames(forName: sender.text!) { (streets, error) in
                if error == nil {
                    self.bestMatches = []
                    for street in streets! {
                        self.bestMatches.append(street)
                    }
                    self.streetSuggestionsDataSource.bestMatches = self.bestMatches
                    self.resultsTableView.reloadData()
                }
            }
        } else if sender.text?.characters.count == 0 {
            self.bestMatches = []
            self.streetSuggestionsDataSource.bestMatches = self.bestMatches
            self.resultsTableView.reloadData()
            self.originTextfield.keyboardType = UIKeyboardType.Alphabet
            self.originTextfield.resignFirstResponder()
            self.originTextfield.becomeFirstResponder()
        }
    }

    // MARK: - Memory Management Methods

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
