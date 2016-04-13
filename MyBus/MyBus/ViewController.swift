//
//  ViewController.swift
//  MyBus
//
//  Created by Marcos Vivar on 4/12/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit
import Mapbox

class ViewController: UIViewController, MGLMapViewDelegate {
    
    @IBOutlet var mapView : MGLMapView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mapView.userTrackingMode = .Follow
        mapView.delegate = self
    }
    
    func mapView(
        mapView: MGLMapView,
        didUpdateUserLocation userLocation: MGLUserLocation?) {
        //Move map to current user location 
        mapView.centerCoordinate = (userLocation!.location?.coordinate)!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

