//
//  ViewController.swift
//  MyBus
//
//  Created by Marcos Vivar on 4/12/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit
import Mapbox

class ViewController: UIViewController {

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let styleURL = NSURL(string: "https://www.mapbox.com/ios-sdk/files/mapbox-raster-v8.json")
        
        let mapView = MGLMapView(frame: view.bounds, styleURL: styleURL)
        mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        mapView.userTrackingMode = .Follow
        
        // Set the map's center coordinate
        mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: -38.0174483, longitude: -57.5258858), zoomLevel: 14, animated: false)
        
        view.addSubview(mapView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

