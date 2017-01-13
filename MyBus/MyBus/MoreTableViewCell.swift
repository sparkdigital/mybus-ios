//
//  MoreTableViewCell.swift
//  MyBus
//
//  Created by Sebastian Fink on 12/16/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit

class MoreSectionModel {
    var iconPath:String?
    var sectionName:String?
    var executeAction:((_ sender:AnyObject)->Void)
    
    init(path:String, sectionName:String, action:@escaping (_ sender:AnyObject)->Void){
        self.iconPath = path
        self.sectionName = sectionName
        self.executeAction = action
    }
    
    func getIconImage()->UIImage?{
        if let path = iconPath {
            return UIImage(named: path)
        }
        return nil
    }
    
}

class MoreTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView:UIImageView!
    @IBOutlet weak var sectionLabel:UILabel!
    var moreModel:MoreSectionModel? {
        didSet{
            self.reloadCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func reloadCell(){
        
        guard let model = self.moreModel else {
            NSLog("Cell model is nil")
            return
        }
        
        self.iconImageView.image = model.getIconImage()
        self.iconImageView.contentMode = UIViewContentMode.scaleAspectFit
        
        self.sectionLabel.text = model.sectionName
        
    }

}
