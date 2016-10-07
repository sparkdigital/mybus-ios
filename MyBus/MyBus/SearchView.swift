//
//  SearchView.swift
//  MyBus
//
//  Created by Julieta Gonzalez Poume on 9/28/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit

class SearchView:UIView{
    
    private var nibId:String = "SearchView"
    private var viewHeight:CGFloat = 84
    
    //View Outlets
    @IBOutlet weak var invert: UIButton!
    @IBOutlet weak var origin: UITextField!
    @IBOutlet weak var destination: UITextField!
    
    override init(frame: CGRect) {
        let rect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, viewHeight)
        super.init(frame: rect)
        xibSetup(nibIdentifier())
    }
    
    required init?(coder aDecoder:NSCoder){
        super.init(coder: aDecoder)
        xibSetup(nibIdentifier())
    }
    
    /*
    func LoadSearchView(currentView : UIView){
        let searchView = UINib(nibName:"SearchView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
        currentView.addSubview(searchView)
    }*/
    
    
}

extension SearchView:SearchPresenter {

    // MARK: SearchPresenter Delegate methods
    func nibIdentifier() -> String{
        return nibId
    }
    
    func preferredHeight() -> CGFloat {
        return viewHeight
    }
    
    func setBarDelegate(delegate: UISearchBarDelegate) {
        // Do nothing
    }
    
    func setTextFieldDelegate(delegate: UITextFieldDelegate) {
        self.origin.delegate = delegate
        self.destination.delegate = delegate
    }

}
