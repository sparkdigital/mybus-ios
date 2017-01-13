//
//  SimpleSearchBarView.swift
//  MyBus
//
//  Created by Sebastian Fink on 10/7/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit

class SimpleSearchBarView: UIView {
    
    fileprivate var nibId: String = "SimpleSearchBarView"
    fileprivate var viewHeight:CGFloat = 44
    @IBOutlet weak var searchBar: UISearchBar!
    
    override init(frame: CGRect) {
        let rect = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: viewHeight)
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
    
    func setSearchDelegate(_ delegate: Searchable) {
        self.searchBar.delegate = delegate as? UISearchBarDelegate
    }
  
}
