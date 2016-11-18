//
//  BusesResultsMenuViewController.swift
//  MyBus
//
//  Created by Sebastian Fink on 11/16/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit
import PageMenu

class BusesResultsMenuViewController: UIViewController {
    
    var pageMenu : CAPSPageMenu?
    var busRouteOptions: [BusRouteResult]?
    var controllerArray:[BusResultViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setup()
   }
    
    func setup(){
        if let options = busRouteOptions {
            controllerArray = buildControllers(options)
        }
        
        let parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 1.0)),
            .ViewBackgroundColor(UIColor.blueColor()),  //color del contenedor debajo de la vista del controller, solo funciona si el controller ingresado tiene el backcolor en ClearColor
            .SelectionIndicatorColor(UIColor.orangeColor()), //color de la linea debajo de la seleccion
            .SelectionIndicatorHeight(2.0), //linea corta debajo de la seleccion
            .AddBottomMenuHairline(false), //linea continua debajo del menu
            .BottomMenuHairlineColor(UIColor.greenColor()),//color de la linea continua debajo del menu
            .MenuItemFont(UIFont(name: "HelveticaNeue", size: 35.0)!),
            .MenuHeight(50.0),
            .MenuItemWidthBasedOnTitleTextWidth(true),
            .SelectedMenuItemLabelColor(UIColor.orangeColor()) //color del tab seleccionado
        ]
        
        let layoutFrameFull:CGRect = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        let layoutFramePortion:CGRect = CGRectMake(0, 60, self.view.frame.width, 150)
        
        
        initializeTabbedMenu(controllerArray, parameters: parameters, frame: layoutFrameFull, delegate: self)
       
    }
    
    
    func initializeTabbedMenu(controllers:[BusResultViewController], parameters:[CAPSPageMenuOption], frame:CGRect, delegate:CAPSPageMenuDelegate?) {
        
        pageMenu = CAPSPageMenu(viewControllers: controllers, frame: frame, pageMenuOptions: parameters)
        pageMenu?.delegate = delegate
        
        self.view.addSubview(pageMenu!.view)
        
    }
    
    func buildControllers(results:[BusRouteResult]) -> [BusResultViewController]{
        
        return results.map({ (routeResult) -> BusResultViewController in
            let busResultVC = BusResultViewController()
            busResultVC.routeResult = routeResult
            return busResultVC
        })
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension BusesResultsMenuViewController:CAPSPageMenuDelegate {
    
    func willMoveToPage(controller: UIViewController, index: Int){
        NSLog("moving to page")
    }
    
    func didMoveToPage(controller: UIViewController, index: Int){
        
        //didSelectItemAtMenuPath
        
        NSLog("did move to page")
    }
}