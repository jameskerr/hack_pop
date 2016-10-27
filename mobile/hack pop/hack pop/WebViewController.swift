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
    @IBOutlet weak var commentsImage: UIImageView!
    @IBOutlet weak var storyImage: UIImageView!
    @IBOutlet weak var commentsButton: UIControl!
    
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
        
        view.layer.masksToBounds = false
        view.layer.borderColor = UIColor.clear.cgColor
        view.layer.shadowColor = UIColor.clear.cgColor
        
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
    
    func loadWebView(ignoreReloading:Bool = false) {
        if let url = Story.current?.url {
            let request = URLRequest(url: url)
            webView.delegate = self
            
            if let currentUrl = Story.current?.url!,
                let currentUrlString = currentUrl.absoluteString as String?,
                !hasLoadedOnce || url.absoluteString != currentUrlString || ignoreReloading {
                webView.loadRequest(request)
            }
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
        webView.stopLoading()
        homeViewInteractor.animateTransition()
    }
    
    @IBAction func swipeBackHome(_ sender: AnyObject) {
        webView.stopLoading()
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
        if let story = originalStory {
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
    
    @IBAction func openCommentsOrStory(_ sender: AnyObject) {
        
        if let storyUrlString = webView.request?.url?.absoluteString,
            let originalStoryCommentsUrlString = originalStory?.commentsUrl?.absoluteString  {
            if storyUrlString == originalStoryCommentsUrlString {
                // then we are on the comments page
                Story.current?.url = originalStory?.url
            } else {
                // then we should navigate to the comments page
                Story.current?.url = originalStory?.commentsUrl
            }
            loadWebView(ignoreReloading: true)
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
        
        if let story = Story.current {
            if story.isUnreadStory {
                story.delete()
            }
        }
        renderCommentsButton()

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
    
    func showCommentsImage() {
        storyImage.isHidden = true
        commentsImage.isHidden = false
    }
    
    func showStoryImage() {
        commentsImage.isHidden = true
        storyImage.isHidden = false
    }
    
    func renderCommentsButton() {
        // if there is a comments url in the original story then show that if that is not the current url
        // otherwise show the story image
        if let storyUrlString = webView.request?.url?.absoluteString,
           let originalStoryCommentsUrlString = originalStory?.commentsUrl?.absoluteString,
           let originalStoryUrlString = originalStory?.url?.absoluteString,
            originalStoryCommentsUrlString != originalStoryUrlString{
            commentsButton.isHidden = false
            
            if storyUrlString == originalStoryCommentsUrlString {
                // then we are on the comments page
                showStoryImage()
            } else if originalStoryCommentsUrlString == originalStory?.url?.absoluteString {
                // then this story has no comments sections because it is the comments section
                // so just show the story button
                showStoryImage()
            } else {
                showCommentsImage()
            }
        } else {
            // it must be the default hacker news case so don't show anything
            // or it must be a hacker news story
            commentsButton.isHidden = true
        }
    }
}

extension WebViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (!connectionFailureView.isHidden) {
            connectionFailureView.isHidden = true
            webViewIndicator.startAnimating()
            loadWebView(ignoreReloading: true)
        }
    }
    
}
