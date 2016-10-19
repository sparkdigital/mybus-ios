//
//  FavoriteTableViewCell.swift
//  MyBus
//
//  Created by Julieta Gonzalez Poume on 9/15/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var address: UITextField!
    
    func loadItem(name: String,street: String,number: String) {
        self.name.text = name
        self.address.text = street+" "+number
        self.name.userInteractionEnabled = false
        self.address.userInteractionEnabled = false
    }
    
    func editCell() {
        self.name.userInteractionEnabled = true
        self.name.becomeFirstResponder()
        self.address.userInteractionEnabled = true
    }
    
    @IBAction func nameEndOnExit(sender: AnyObject) {
        self.name.userInteractionEnabled = false
        self.name.resignFirstResponder()
        self.address.becomeFirstResponder()
        //TODO save field in bd
    }
    
    @IBAction func addressEndOnExit(sender: AnyObject) {   self.name.userInteractionEnabled = false
        self.address.userInteractionEnabled = false
        self.address.resignFirstResponder()
        //TODO save field in bd
    }
    
}