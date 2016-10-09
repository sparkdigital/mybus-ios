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
    func setBarDelegate(delegate:UISearchBarDelegate)
    func setTextFieldDelegate(delegate:Searchable)
}

class MapSearchViewContainer: UIView {
    
    var presenter:SearchPresenter!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder:NSCoder){
        super.init(coder: aDecoder)
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
        presenter = aPresenter
        clearViewSubviews()
        addAutoPinnedSubview(presenter as! UIView, toView: self)
    }
    
    
}
