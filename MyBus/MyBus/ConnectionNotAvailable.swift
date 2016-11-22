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
    
    override func viewDidLoad(){
        super.viewDidLoad()
        let singleTap = UILongPressGestureRecognizer(target: self, action: #selector(self.singleTap(_:)))
        self.view.addGestureRecognizer(singleTap)
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
