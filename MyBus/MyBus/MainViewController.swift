//
//  MainViewController.swift
//  MyBus
//
//  Created by Lisandro Falconi on 7/11/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class MainViewController: UIViewController, MapBusRoadDelegate  {

    //Reference to the container view
    @IBOutlet weak var containerView: UIView!

    var mapViewController: ViewController!
    var searchViewController: SearchViewController!

    //Reference to the currentViewController being shown
    weak var currentViewController: UIViewController?

    //Storyboard view controller identifiers
    let kSearchViewIdentifier: String = "SearchViewController"
    let kMapViewIdentifier: String = "MapViewController"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapViewController = self.buildComponentVC(kMapViewIdentifier) as! ViewController
        self.searchViewController = self.buildComponentVC(kSearchViewIdentifier) as! SearchViewController
        self.currentViewController = mapViewController
        self.currentViewController?.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.currentViewController!)
        self.addSubview(self.currentViewController!.view, toView: self.containerView)
    }

    //Method that receives a storyboard string identifier and returns a view controller object
    func buildComponentVC(identifier: String)->UIViewController{
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(identifier)
    }

    //Method that receives a subview and adds it to the parentView with autolayout constraints
    func addSubview(subView: UIView, toView parentView: UIView) {
        parentView.addSubview(subView)

        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
    }

    //This method receives the old view controller to be replaced with the new controller
    func cycleViewController(oldVC: UIViewController, toViewController newVC: UIViewController){

        //If it's triggered by the same button, dismiss action
        if oldVC == newVC {
            return
        }

        oldVC.willMoveToParentViewController(nil)
        self.addChildViewController(newVC)

        //Add new view to the container
        self.addSubview(newVC.view, toView: self.containerView)

        newVC.view.alpha = 0
        newVC.view.layoutIfNeeded()

        UIView.animateWithDuration(0.5, animations: {
            newVC.view.alpha = 1.0
            oldVC.view.alpha = 0.0
            }, completion:{
                finished in

                oldVC.view.removeFromSuperview()
                oldVC.removeFromParentViewController()
                newVC.didMoveToParentViewController(self)
        })


    }

    // MARK: - IBAction Methods

    @IBAction func searchButtonTapped(sender: AnyObject)
    {
        let vc: SearchViewController = self.buildComponentVC(kSearchViewIdentifier) as! SearchViewController
        vc.searchViewProtocol = self
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        self.cycleViewController(self.currentViewController!, toViewController: vc)
        self.currentViewController = vc
    }

    // MARK: - MapBusRoadDelegate Methods

    func newBusRoad(mapBusRoad: MapBusRoad)
    {
        self.mapViewController.addBusRoad(mapBusRoad)
    }

    func newResults(results: [String])
    {
        self.mapViewController.addBusLinesResults(results)
        self.mapViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.cycleViewController(self.currentViewController!, toViewController: self.mapViewController)
        self.currentViewController = self.mapViewController
    }

    func newOrigin(origin: CLLocationCoordinate2D, address: String)
    {
        self.mapViewController.addOriginPosition(origin, address: address)
    }

    func newDestination(destination: CLLocationCoordinate2D, address: String)
    {
        self.mapViewController.addDestinationPosition(destination, address : address)
    }

    func detailBusRoadResults(mapBusRoads: [MapBusRoad])
    {
        self.mapViewController.addDetailedBusRoadResults(mapBusRoads)
    }

}
