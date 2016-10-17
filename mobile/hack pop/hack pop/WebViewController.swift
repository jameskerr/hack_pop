//
//  WebViewController.swift
//  hack pop
//
//  Created by Jamie Sunderland on 9/22/16.
//  Copyright © 2016 james inc. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

class WebViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webViewIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var connectionFailureView: UIScrollView!
    @IBOutlet weak var backButtonImage: UIImageView!
    @IBOutlet weak var forwardButtonImage: UIImageView!
    
    var originalStory:Story? = nil
    var hasLoadedOnce:Bool = false
    var homeViewInteractor:Interactor!
    let fourOhFour = -1009
    
    // set to portrait mode always
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask(rawValue: UIInterfaceOrientationMask.portrait.rawValue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         Flurry.logEvent("opened webview view controller")
        
        view.layer.borderColor = UIColor.clear.cgColor
        
        originalStory = Story.current?.copy() as? Story
        webView.backgroundColor = UIColor.lightGray
        webView.allowsLinkPreview = true
        webView.allowsInlineMediaPlayback = true
        
        updateNavigationButtonImages()
        let destinationControllerIdentifier =
        (Story.current?.isUnreadStory)! ? "RecentStoriesViewController" : "HomeViewController"
        homeViewInteractor = Interactor(delegateViewController:self,
                                        dimissing:true,
                                        destinationIdentifier:destinationControllerIdentifier,
                                        direction:.LeftToRight,
                                        complete: { viewController in
                                            if viewController is RecentStoriesViewController {
                                                let recentStoriesViewController = viewController as! RecentStoriesViewController
                                                recentStoriesViewController.startAnimation()
                                            }
                                        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadWebView();
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
    
    
    func updateNavigationButtonImages() {
        if webView.canGoBack {
            backButtonImage.image = #imageLiteral(resourceName: "back_arrow_active")
        } else {
            backButtonImage.image = #imageLiteral(resourceName: "back_arrow_inactive")
        }
        
        if webView.canGoForward {
            forwardButtonImage.image = #imageLiteral(resourceName: "forward_arrow_active")
        } else {
            forwardButtonImage.image = #imageLiteral(resourceName: "forward_arrow_inactive")
        }
    }
    
    @IBAction func handleSwiipe(_ sender: UIPanGestureRecognizer) {
        homeViewInteractor.updateGestureMotion(sender: sender)
    }
    
    @IBAction func goBack() {
        homeViewInteractor.animateTransition()
    }
    
    @IBAction func swipeBackHome(_ sender: AnyObject) {
        homeViewInteractor.animateTransition()
    }
    
    @IBAction func historyGoBack() {
        if webView.canGoBack {
            connectionFailureView.isHidden = true
            webViewIndicator.startAnimating()
            webView.goBack()
        }
    }
    
    @IBAction func historyGoForward() {
        if webView.canGoForward {
            connectionFailureView.isHidden = true
            webViewIndicator.startAnimating()
            webView.goForward()
        }
    }
    
    @IBAction func shareArticle() {
        if let story = Story.current {
            let shareContent:[Any] = [story.title, story.url!]

            let activityViewController = UIActivityViewController(activityItems: shareContent, applicationActivities: nil)

            activityViewController.excludedActivityTypes = [
                UIActivityType.assignToContact,
                UIActivityType.airDrop,
                UIActivityType.saveToCameraRoll,
                UIActivityType.openInIBooks,
                UIActivityType.print,
                UIActivityType.postToVimeo,
                UIActivityType.postToFlickr,
                UIActivityType.postToTencentWeibo
            ]
            present(activityViewController, animated: true, completion: {})
        }
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
        if error._code == fourOhFour {
            connectionFailureView.isHidden = false
            webView.isHidden = true
            updateNavigationButtonImages()
            webViewIndicator.stopAnimating()
        }
    }
    
    func webViewDidStartLoad(_:UIWebView) {
        webView.isHidden = false
        updateNavigationButtonImages()
        webViewIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_:UIWebView) {
        
        if let story  = Story.current {
            if story.isUnreadStory {
                story.delete()
            }
        }

        connectionFailureView.isHidden = true
        if (hasLoadedOnce || (Story.current?.isHackerNews)!) {
            //modify the story
            if let story = Story.current {
                story.url = webView.request?.url
                story.title = webView.stringByEvaluatingJavaScript(from: "document.title")!
            }
            
        } else {
            hasLoadedOnce = true
        }
        updateNavigationButtonImages()
        webViewIndicator.stopAnimating()
    }
}

extension WebViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (!connectionFailureView.isHidden) {
            connectionFailureView.isHidden = true
            webViewIndicator.startAnimating()
            loadWebView()
        }
    }
    
}
