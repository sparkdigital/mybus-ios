//
//  BusesResultsMenuViewController.swift
//  MyBus
//
//  Created by Sebastian Fink on 11/16/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit
import PageMenu

protocol BusesResultsMenuDelegate {
    func didSelectBusRouteOption(_ busRouteSelected: BusRouteResult)
}

enum BusesResultsMenuStatusNotification: String {
    case Collapsed = "com.mybus.busesmenucollapsed"
    case Expanded  = "com.mybus.busesmenuexpanded"
}

class BusesResultsMenuViewController: UIViewController {

    var pageMenu: CAPSPageMenu?
    var busRouteOptions: [BusRouteResult]?
    var controllerArray: [BusResultViewController] = []
    var busResultDelegate: BusesResultsMenuDelegate?

    var currentRouteSelectedViewController: BusResultViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func setup(_ busOptions: [BusRouteResult]?){

        self.busRouteOptions = busOptions

        if let options = busRouteOptions {
            controllerArray = buildControllers(options)
        }

        if controllerArray.count > 0 {
            currentRouteSelectedViewController = controllerArray.first
        }

        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)),
            .viewBackgroundColor(UIColor.clear),  //color del contenedor debajo de la vista del controller, solo funciona si el controller ingresado tiene el backcolor en ClearColor
            .selectionIndicatorColor(UIColor.orange), //color de la linea debajo de la seleccion
            .selectionIndicatorHeight(2.0), //linea corta debajo de la seleccion
            .addBottomMenuHairline(false), //linea continua debajo del menu
            .bottomMenuHairlineColor(UIColor.green),//color de la linea continua debajo del menu
            .menuItemFont(UIFont(name: "HelveticaNeue", size: 20.0)!),
            .menuHeight(50.0),
            .menuItemWidthBasedOnTitleTextWidth(true),
            .selectedMenuItemLabelColor(UIColor.orange), //color del tab seleccionado,
            .unselectedMenuItemLabelColor(UIColor.black)
        ]

        let layoutFrameFull: CGRect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)

        initializeTabbedMenu(controllerArray, parameters: parameters, frame: layoutFrameFull, delegate: self)

    }


    func initializeTabbedMenu(_ controllers: [BusResultViewController], parameters: [CAPSPageMenuOption], frame: CGRect, delegate: CAPSPageMenuDelegate?) {

        pageMenu = CAPSPageMenu(viewControllers: controllers, frame: frame, pageMenuOptions: parameters)
        pageMenu?.delegate = delegate

        self.view.addSubview(pageMenu!.view)

    }

    func buildControllers(_ results: [BusRouteResult]) -> [BusResultViewController]{

        return results.map({ (routeResult) -> BusResultViewController in
            let busResultVC = BusResultViewController()
            busResultVC.routeResult = routeResult
            return busResultVC
        })

    }

    func setOptionSelected(_ preselectedIndex: Int){
        if let _ = busRouteOptions?[preselectedIndex] {
            self.currentRouteSelectedViewController = controllerArray[preselectedIndex]
            self.pageMenu?.moveToPage(preselectedIndex)
        }
        return
    }

    func updateCurrentOptionWithFetchedRoad(_ roadResult: RoadResult){
        if let current = self.currentRouteSelectedViewController {
            current.roadResult = roadResult
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension BusesResultsMenuViewController:CAPSPageMenuDelegate {

    func willMoveToPage(_ controller: UIViewController, index: Int){
        //NSLog("moving to page")
    }

    func didMoveToPage(_ controller: UIViewController, index: Int){

        //NSLog("did move to page")
        guard let currentOption = controller as? BusResultViewController else {
            NSLog("Couldn't cast ")
            return
        }
        self.currentRouteSelectedViewController = currentOption

        self.busResultDelegate?.didSelectBusRouteOption(currentRouteSelectedViewController!.routeResult)
    }
}
