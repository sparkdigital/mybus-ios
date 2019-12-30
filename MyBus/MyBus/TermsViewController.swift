//
//  TermsViewController.swift
//  MyBus
//
//  Created by Sebastian Fink on 12/16/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController, UIWebViewDelegate  {

    @IBOutlet weak var webView: UIWebView!
    static let termsHTMLFile:(path: String, type: String) = ("MyBus_Terms_And_Conditions", "html")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Get local path of local html resource
        guard let path = Bundle.main.path(forResource: TermsViewController.termsHTMLFile.path, ofType: TermsViewController.termsHTMLFile.type) else {
            NSLog("Couldn't find the local html path")
            return
        }

        self.view.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.0)
        webView.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.0)

        //Build URL and Request based in the html content of the file
        let url = URL(fileURLWithPath: path)
        let request = URLRequest(url: url)
        webView.scalesPageToFit = true
        webView.delegate = self
        webView.loadRequest(request)

        let titleView = UINib(nibName:"TitleMainView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView

        let doneBarButtonItem: UIBarButtonItem = UIBarButtonItem(title: "Listo", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissTerms))
        doneBarButtonItem.tintColor = UIColor.white

        self.navigationItem.titleView = titleView
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = doneBarButtonItem

        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.00, green:0.51, blue:0.81, alpha:1.0)
        self.navigationController?.navigationBar.isTranslucent = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }

    @objc func dismissTerms(){
        let _ = self.applyTransitionAnimation(withDuration: 0.4, transitionType: TransitionType.moveIn, transitionSubType: TransitionSubtype.fromTop)
        self.dismiss(animated: false, completion: nil)
    }

    // MARK: UIWebViewDelegate protocol methods
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {

        if navigationType == UIWebView.NavigationType.linkClicked {
            //A Link was tapped
            NSLog("Link Tapped")

            if let urlLink = request.url {
                //Open external link in device's browser
                UIApplication.shared.openURL(urlLink)
            }

            return false

        }else{
            //It wasn't a link => Page Load
            NSLog("Something was tapped. Not Link")
            return true
        }
    }
}
