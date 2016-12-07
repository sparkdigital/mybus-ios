//
//  UIViewLayoutExtensions.swift
//  MyBus
//
//  Created by Sebastian Fink on 10/7/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit

extension UIView {
    
    func xibSetup(nibID:String){
        if let v = self.initFromNibFile(nibID) {
            self.addSubview(v)
        }
    }
    
    func initFromNibFile(fileIdentifier:String)->UIView?{
        guard let contentView:UIView = NSBundle.mainBundle().loadNibNamed(fileIdentifier, owner: self, options: nil).first as? UIView else {
            NSLog("Couldn't load nib file named: \(fileIdentifier)")
            return nil
        }
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        return contentView
    }
    
    //Method that receives a subview and adds it to the parentView with autolayout constraints
    func addAutoPinnedSubview(subView: UIView, toView parentView: UIView) {
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
    }
    
    func addPinnedSubviewWithHandleToParent(subView:UIView, handleView:UIView, toView parentView:UIView){
        parentView.addSubview(subView)
        parentView.addSubview(handleView)
        
        var viewBindingsDict = [String:AnyObject]()
        viewBindingsDict["subView"] = subView
        viewBindingsDict["handleView"] = handleView
        
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-100-[handleView]-100-|",
            options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]-0-[handleView]-0-|",
            options: [], metrics: nil, views: viewBindingsDict))
        
    }
    
    func clearViewSubviews(){
        let subViews = self.subviews
        for v in subViews {
            v.removeFromSuperview()
        }
    }
    
}