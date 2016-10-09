//
//  SimpleSearchBarView.swift
//  MyBus
//
//  Created by Sebastian Fink on 10/7/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit

class SimpleSearchBarView: UIView {
    
    private var nibId: String = "SimpleSearchBarView"
    private var viewHeight:CGFloat = 44
    @IBOutlet weak var searchBar: UISearchBar!
    
    override init(frame: CGRect) {
        let rect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, viewHeight)
        super.init(frame: rect)
        xibSetup(nibIdentifier())
    }
    
    required init?(coder aDecoder:NSCoder){
        super.init(coder: aDecoder)
        xibSetup(nibIdentifier())
    }

}

extension SimpleSearchBarView:SearchPresenter {
    
    // MARK: SearchPresenter Delegate methods
    func nibIdentifier() -> String{
        return nibId
    }
    
    func preferredHeight() -> CGFloat {
        return viewHeight
    }
    
    func setBarDelegate(delegate: UISearchBarDelegate) {
        self.searchBar.delegate = delegate
    }
    
    func setTextFieldDelegate(delegate: Searchable) {
        // Do nothing
    }
   
}