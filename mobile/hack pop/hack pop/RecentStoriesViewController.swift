//
//  RecentStoriesViewController.swift
//  hack pop
//
//  Created by Jamie Sunderland on 9/27/16.
//  Copyright © 2016 james inc. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

class RecentStoriesViewController: UIViewController {
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var connectionFailureView: UIScrollView!
    @IBOutlet weak var recentStoriesTable: UITableView!
    @IBOutlet weak var noUnreadStoriesContainer: UIView!
    @IBOutlet weak var unreadStoriesLabel: UILabel!
    @IBOutlet weak var sunImage: UIImageView!
    @IBOutlet weak var leftBigCloud: UIImageView!
    @IBOutlet weak var rightBigCloudTop: UIImageView!
    @IBOutlet weak var rightBigCloudBottom: UIImageView!
    
    var stories:[Story]? = nil
    var homeViewInteractor:Interactor!
    var webViewInteractor:Interactor!
    var loadedOnce = false

    let cellHeight:CGFloat = 70
    
    // set to portrait mode always
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask(rawValue: UIInterfaceOrientationMask.portrait.rawValue)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Flurry.logEvent("opened recent stories view controller")
        
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.clear.cgColor
        
        homeViewInteractor = Interactor(delegateViewController:self,
                                        dimissing:true,
                                        destinationIdentifier:"HomeViewController",
                                        direction:.RightToLeft,
                                        complete: nil)
        
        webViewInteractor = Interactor(delegateViewController:self,
                                       dimissing:false,
                                       destinationIdentifier:"WebViewController",
                                       direction:.RightToLeft,
                                       complete: nil)
        HackPopStyle.StyleTopStoriesTableView(tableView: recentStoriesTable)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setup),
                                               name: NSNotification.Name.UIApplicationDidBecomeActive,
                                               object: nil)
        
        DispatchQueue.main.async {
            self.setup()
        }
    }
    
    func setup() {
        CATransaction.flush()
        let token = Client.instance().token
        HackPopServer.fetchNotifcations(id: token, delegate: self)
        
        view.layer.borderColor = UIColor.clear.cgColor
        unreadStoriesLabel.text = "Loading Stories..."
        loadingIndicator.startAnimating()
        loadingView.isHidden = false
        noUnreadStoriesContainer.isHidden = true
        recentStoriesTable.isHidden = true
        connectionFailureView.isHidden = true
        
    }
    
    func displayFailedToLoad() {
        unreadStoriesLabel.text = "Couldn't Load Stories"
        noUnreadStoriesContainer.isHidden = true
        recentStoriesTable.isHidden = true
        loadingView.isHidden = true
        connectionFailureView.isHidden = false
        
    }
    
    func displayStoriesLoaded() {
        loadingView.isHidden = true
        
        connectionFailureView.isHidden = true
        if stories != nil && (stories?.count)! > 0 {
            DispatchQueue.main.async {
                self.loadingIndicator.stopAnimating()
                self.showUnreadStories()
            }
        } else {
            DispatchQueue.main.async {
                self.loadingIndicator.stopAnimating()
                self.showNoUnreadStories()
            }
        }
    }
    
    func showUnreadStories() {
        CATransaction.flush()
        recentStoriesTable.isHidden = false
        loadingView.isHidden = true
        noUnreadStoriesContainer.isHidden = true
        unreadStoriesLabel.text = "Unread Stories"
        DispatchQueue.main.async {
            self.recentStoriesTable.reloadData()
        }
    }
    
    func showNoUnreadStories() {
        CATransaction.flush()
        recentStoriesTable.isHidden = true
        noUnreadStoriesContainer.isHidden = false
        unreadStoriesLabel.text = "No Unread Stories"
        startAnimation()
    }
    
    func startAnimation() {
        let topViewController = UIApplication.topViewController()
        AppDelegate.delay(delay: 0, closure: {
            if topViewController is RecentStoriesViewController &&
                Story.lastStoryWasEndOfNotifications {
                Story.lastStoryWasEndOfNotifications = false
                self.moveClouds()
            } else {
                self.moveCloudsWithoutAnimating()
            }
        })
    }
    
    func moveCloudsWithoutAnimating() {
        let screenFrame = UIScreen.main.bounds
        leftBigCloud.frame.origin.x = -(screenFrame.size.width)
        rightBigCloudTop.frame.origin.x = screenFrame.size.width
        rightBigCloudBottom.frame.origin.x = screenFrame.size.width
    }
    
    func moveClouds() {
        leftBigCloud.isHidden = false
        rightBigCloudTop.isHidden = false
        rightBigCloudBottom.isHidden = false
        
        let screenFrame = UIScreen.main.bounds
        UIView.animate(withDuration: 1,
                       animations: {
                        self.leftBigCloud.frame.origin.x = -(screenFrame.size.width)
            }, completion: nil)
        
        UIView.animate(withDuration: 1.5,
                       animations: {
                        self.rightBigCloudTop.frame.origin.x = screenFrame.size.width
            }, completion: nil)
        
        UIView.animate(withDuration: 1,
                       animations: {
                        self.rightBigCloudBottom.frame.origin.x = screenFrame.size.width
            }, completion: nil)
        
        AppDelegate.delay(delay: 0.2, closure: {
            self.spinSun()
        })
    
    }
    
    func spinSun() {
        
        let duration:TimeInterval = 2.5
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: [UIViewAnimationOptions.curveEaseInOut],
                       animations: {
            self.sunImage.transform = CGAffineTransform(rotationAngle: (90.0 * CGFloat(M_PI)) / 180.0)
        }, completion: nil)
    
    }

    @IBAction func handleSwipe(_ sender: UIPanGestureRecognizer) {
        leftBigCloud.isHidden = true
        rightBigCloudTop.isHidden = true
        rightBigCloudBottom.isHidden = true
        homeViewInteractor.updateGestureMotion(sender: sender)
    }
    
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent;
    }
}

extension RecentStoriesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
        if let stories = stories {
            return stories.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let story = stories?[(indexPath as NSIndexPath).row]
        return HackPopStyle.GetStyledStoryCell(story!)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let story = stories?[(indexPath as NSIndexPath).row]
        Flurry.logEvent("opened story from recent stories table")
        Story.current = story
        Story.current?.isUnreadStory = true
        webViewInteractor?.animateTransition()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
}

extension RecentStoriesViewController: HttpNotificationsFetchListener {
    func onFetchNotifcationsSuccess(stories: [Story]?) {
        self.stories = stories
        displayStoriesLoaded()
    }
    
    func onFetchNotifcationsFailed(error: Error?) {
        if let _ = error {
            Flurry.logEvent("failed to load unread stories")
        }
        
        AppDelegate.delay(delay: 0.0) {
            self.displayFailedToLoad()
        }
        
    }
}

extension RecentStoriesViewController: UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (!connectionFailureView.isHidden) {
            DispatchQueue.main.async {
                self.setup()
            }
        }
    }
    
}

