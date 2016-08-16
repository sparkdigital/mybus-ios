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
    let progressNotification = ProgressHUD()

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

        if originTextFieldValue.isEmpty || destinationTextFieldValue.isEmpty{
            let message = originTextFieldValue.isEmpty ? "El Origen no esta indicado": "El campo Destino no esta indicado"
            GenerateMessageAlert.generateAlert(self, title: "No sabemos que buscar", message: message)
        }
        else{
            progressNotification.showLoadingNotification(self.view)
//            SearchManager.sharedInstance.search(originTextFieldValue, destination: destinationTextFieldValue, callback: )

            progressNotification.stopLoadingNotification(self.view)
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
