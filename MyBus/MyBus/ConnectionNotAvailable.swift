//
//  ConnectionNotAvailable.swift
//  MyBus
//
//  Created by Nacho on 11/8/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit

protocol ConnectionNotAvailableProtocol {
    func didTapRetry()
}

class ConnectionNotAvailable: UIViewController {

    var delegate : ConnectionNotAvailableProtocol!
    
    @IBOutlet weak var blackView: UIView!
    @IBOutlet var backgroundView: UIView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        let singleTap = UILongPressGestureRecognizer(target: self, action: #selector(self.singleTap(_:)))
        self.view.addGestureRecognizer(singleTap)
        self.setupUI()
    }
    
    func setupUI(){
        self.blackView.opaque = false
        self.blackView.layer.cornerRadius = 10
        self.blackView.backgroundColor =  UIColor.init(red: 68/255, green: 68/255, blue:68/255, alpha: 0.7)
        
        self.backgroundView.opaque = true
        self.backgroundView.layer.cornerRadius = 10
        self.backgroundView.backgroundColor = UIColor.init(red: 250/255, green: 250/255, blue:250/255, alpha: 0.4)
      
    }
    
    func singleTap(sender:UITapGestureRecognizer){
        delegate.didTapRetry()
    }

    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func didTapRetryButton(sender: UIButton){
        delegate.didTapRetry()
    }

    @IBAction func didTouchRetryImage(sender: UIButton) {
    }
    
    
   
}
