//
//  MapSearchViewContainer.swift
//  MyBus
//
//  Created by Sebastian Fink on 10/7/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit

protocol SearchPresenter{
    func nibIdentifier() -> String
    func preferredHeight() -> CGFloat
    func setSearchDelegate(delegate:Searchable)    
}

class MapSearchViewContainer: UIView {
    
    static let myBusBlueColor: UIColor = UIColor(red:0.01, green:0.53, blue:0.82, alpha:1.0)
    var presenter:SearchPresenter!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = MapSearchViewContainer.myBusBlueColor
        self.tintColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder:NSCoder){
        super.init(coder: aDecoder)
        self.backgroundColor = MapSearchViewContainer.myBusBlueColor
        self.tintColor = UIColor.clearColor()
    }
    
    func loadBasicSearch(){
        loadConcreteSearchView(SimpleSearchBarView(frame: bounds))
    }
    
    func loadComplexSearch(origin:RoutePoint?, destination:RoutePoint?){
        let complexSearchView = SearchView(frame: bounds)
        complexSearchView.origin.text = origin?.address
        complexSearchView.destination.text = destination?.address
        loadConcreteSearchView(complexSearchView)
    }
    
    private func loadConcreteSearchView(aPresenter:SearchPresenter){
        clearViewSubviews()
        presenter = aPresenter        
        addAutoPinnedSubview(presenter as! UIView, toView: self)
    }
    
    
}
