//
//  SearchView.swift
//  MyBus
//
//  Created by Julieta Gonzalez Poume on 9/28/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit

class SearchView{

    @IBOutlet weak var origin: UITextField!
    
    @IBOutlet weak var destination: UITextField!
    
    @IBOutlet weak var invert: UIImageView!
    
    func LoadSearchView(currentView : UIView){
        let searchView = UINib(nibName:"SearchView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
        currentView.addSubview(searchView)
    }
}