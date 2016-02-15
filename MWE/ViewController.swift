//
//  ViewController.swift
//  MWE
//
//  Created by Sebastian Osiński on 14.02.2016.
//  Copyright © 2016 Sebastian Osiński. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKScriptMessageHandler, WKNavigationDelegate {
    
    var webView: WKWebView!
    
    @IBOutlet weak var loadLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contentController = WKUserContentController()
        
        let scriptPath = NSBundle.mainBundle().pathForResource("script", ofType: "js")!
        let scriptString = try! String(contentsOfFile: scriptPath)
        let script = WKUserScript(source: scriptString, injectionTime: .AtDocumentStart, forMainFrameOnly: true)
        
        contentController.addUserScript(script)
        contentController.addScriptMessageHandler(self, name: "readyHandler")
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController
        
        webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        view.addSubview(webView)
        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        loadLabel.text = nil
    }
    
    @IBAction func loadWebsite() {
        webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://stackoverflow.com")!))
        loadLabel.text = "Loading..."
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        print(webView.estimatedProgress)
    }

    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        print("message received")
        loadLabel.text = "Complete"
    }
}

