//
//  WebViewController.swift
//  hack pop
//
//  Created by Jamie Sunderland on 9/22/16.
//  Copyright © 2016 james inc. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webViewIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.backgroundColor = UIColor.lightGray
        loadWebView();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.}

    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent;
    }
    
    func loadWebView() {
        if let url = Story.current?.url{
            let request = URLRequest(url: url)
            webView.delegate = self
            webView.loadRequest(request)
        }
    }
    
    @IBAction func swipeBackHome(_ sender: AnyObject) {
        performSegue(withIdentifier:"openHomeView", sender: nil)
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
    }
    
    func webViewDidStartLoad(_:UIWebView) {
        webViewIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_:UIWebView) {
        webViewIndicator.stopAnimating()
    }
}
