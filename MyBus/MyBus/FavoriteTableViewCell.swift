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
    @IBOutlet weak var delete: UIButton!
    @IBOutlet weak var edit: UIButton!
    
    func loadItem(name: String,street: String,number: String) {
        self.name.text = name
        self.address.text = street+" "+number
        self.name.userInteractionEnabled = false
        self.address.userInteractionEnabled = false
    }
    
    @IBAction func editCell(sender: AnyObject) {
        self.name.userInteractionEnabled = true
        self.name.becomeFirstResponder()
        self.address.userInteractionEnabled = true
    }
  
    
}