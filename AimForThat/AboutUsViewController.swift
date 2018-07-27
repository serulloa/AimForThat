//
//  AboutUsViewController.swift
//  AimForThat
//
//  Created by Sergio Ulloa on 25/7/18.
//  Copyright © 2018 Sergio Ulloa. All rights reserved.
//

import UIKit
import WebKit

class AboutUsViewController: UIViewController {
    
    // MARK: - Properties
    // MARK: IBOutlets
    @IBOutlet weak var webView: WKWebView!
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = Bundle.main.url(forResource: "AimForThat", withExtension: "html") {
            
            let baseUrl = URL(fileURLWithPath: Bundle.main.bundlePath)
            if let htmlData = try? Data(contentsOf: url) {
                self.webView.load(htmlData, mimeType: "text/html", characterEncodingName: "UTF-8", baseURL: baseUrl )
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: IBActions
    @IBAction func btnBackPressed() {
        dismiss(animated: true, completion: nil)
    }

}
