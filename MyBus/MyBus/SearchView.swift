//
//  SearchView.swift
//  MyBus
//
//  Created by Julieta Gonzalez Poume on 9/28/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit

class SearchView:UIView{
    
    fileprivate var nibId:String = "SearchView"
    fileprivate var viewHeight:CGFloat = 84
    
    //View Outlets
    @IBOutlet weak var invert: UIButton!
    @IBOutlet weak var origin: UITextField!
    @IBOutlet weak var destination: UITextField!
    
    var searchDelegate:Searchable? {
        didSet {
            if let _ = searchDelegate {
                invert.addTarget(self, action: #selector(invertEndpoints), for: UIControlEvents.touchUpInside)
            }
        }
    }
    
    override init(frame: CGRect) {
        let rect = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: viewHeight)
        super.init(frame: rect)
        xibSetup(nibIdentifier())
        self.origin.delegate = self
        self.destination.delegate = self
    }
    
    required init?(coder aDecoder:NSCoder){
        super.init(coder: aDecoder)
        xibSetup(nibIdentifier())
        self.origin.delegate = self
        self.destination.delegate = self
    }
    
    func invertEndpoints(){
        LoggingManager.sharedInstance.logEvent(LoggableAppEvent.INVERT_TAPPED)
        self.searchDelegate?.invertSearch()
    }
   
    
}

extension SearchView:SearchPresenter {

    // MARK: SearchPresenter Delegate methods
    func nibIdentifier() -> String{
        return nibId
    }
    
    func preferredHeight() -> CGFloat {
        return viewHeight
    }
    
    func setSearchDelegate(_ delegate: Searchable) {
        self.searchDelegate = delegate
    }

}

extension SearchView:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField){
        textField.resignFirstResponder()
        
        if textField == origin {
            self.searchDelegate?.newOriginSearchRequest()
        }else{
            self.searchDelegate?.newDestinationSearchRequest()
        }
        
    }
}
