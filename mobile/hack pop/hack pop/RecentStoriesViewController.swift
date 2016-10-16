//
//  RecentStoriesViewController.swift
//  hack pop
//
//  Created by Jamie Sunderland on 9/27/16.
//  Copyright © 2016 james inc. All rights reserved.
//

import UIKit

class RecentStoriesViewController: UIViewController {
    
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
        setup()
        
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
    }
    
    func setup() {
        stories = Story.getSavedStories()
        
        view.layer.borderColor = UIColor.clear.cgColor
        
        if stories?.count == 0 {
            recentStoriesTable.isHidden = true
            noUnreadStoriesContainer.isHidden = false
            unreadStoriesLabel.text = "No Unread Stories"
        } else {
            recentStoriesTable.isHidden = false
            noUnreadStoriesContainer.isHidden = true
            unreadStoriesLabel.text = "Unread Stories"
        }
        
        
        DispatchQueue.main.async {
            self.recentStoriesTable.reloadData()
        }
        
    }
    
    func startAnimation() {
        AppDelegate.delay(delay: 0, closure: {
            self.moveClouds()
        })
    }
    
    func moveClouds() {
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
       homeViewInteractor.updateGestureMotion(sender: sender)
    }
    
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent;
    }
}

extension RecentStoriesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
        return stories!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let story = stories?[(indexPath as NSIndexPath).row]
        return HackPopStyle.GetStyledStoryCell(story!)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let story = stories?[(indexPath as NSIndexPath).row]
        Story.current = story
        webViewInteractor?.animateTransition()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
}

