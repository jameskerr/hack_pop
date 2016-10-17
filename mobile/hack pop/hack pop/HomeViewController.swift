//
//  HomeViewController.swift
//  hack pop
//
//  Created by Jamie Sunderland on 9/14/16.
//  Copyright © 2016 james inc. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

enum HomeTransitions : Int {
    case PointSelection
    case RecentStories
    case WebView
    case null
}


class HomeViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var titleViewContainer: UIView!
    @IBOutlet weak var notifyViewController: UIControl!
    @IBOutlet weak var currentPointValueLabel: UILabel!
    @IBOutlet weak var notifyThresholdContainer: UIControl!
    @IBOutlet weak var topStoriesContainer: UIView!
    @IBOutlet weak var topStoriesLabel: UILabel!
    @IBOutlet weak var connectionFailedView: UIScrollView!
    @IBOutlet weak var thesholdTooLowView: UIView!
    @IBOutlet weak var topStoriesTable: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var topStoriesTableWrapper: UIView!

    // make public so the extensions can have access
    public let pointRetainer = PointsRetainer.instance()
    public let hackPopServer = HackPopServer.instance()
    public let notifyThresholdAnimator = NotifyThresholdAnimationTransition()
    public var stories:[Story]? = nil
    public var filteredStories:[Story]? = nil
    let cellHeight:CGFloat = 70
    
    var recentStoriesInteractor:Interactor? = nil
    var webViewInteractor:Interactor? = nil
    var currentInteractor:Interactor? = nil
    
    
    // set to portrait mode always
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask(rawValue: UIInterfaceOrientationMask.portrait.rawValue)
    }
    
    // get a light status bar 
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Flurry.logEvent("opened home view controller")
        
        createSwipeInteractors()
        view.layer.borderColor = UIColor.clear.cgColor
        setup()
        self.navigationController?.delegate = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reset),
                                               name: NSNotification.Name.UIApplicationDidBecomeActive,
                                               object: nil)
        
    }
    
    func reset() {
        CATransaction.flush()
        setup()
    }
    
    func setup() {
        loadingIndicator.startAnimating()
        hackPopServer.getStories(delegate: self)
        
        HackPopStyle.StyleTopStoriesTableView(tableView: topStoriesTable)
        let attributedString = HackPopStyle.UnderlinedText("\(pointRetainer.value) Points", fontSize: 18)
        currentPointValueLabel.attributedText = attributedString
        topStoriesLabel.text = "Top Stories Over \(pointRetainer.value) Points"
    }
    
    private func createSwipeInteractors() {
        recentStoriesInteractor = Interactor(delegateViewController: self,
                                             dimissing: false,
                                             destinationIdentifier: "RecentStoriesViewController",
                                             direction: .LeftToRight,
                                             complete: { viewController in
                                                let recentStoriesViewController = viewController as! RecentStoriesViewController
                                                recentStoriesViewController.startAnimation()
                                            })
        
        webViewInteractor = Interactor(delegateViewController:self,
                                       dimissing:false,
                                       destinationIdentifier:"WebViewController",
                                       direction:.RightToLeft,
                                       complete: nil)
        
        webViewInteractor?.beforeInteractiveTransition = Story.setCurrentStoryToDefault
    }
    
    @IBAction func changeThreshold(_ sender: AnyObject) {
        
        Flurry.logEvent("pressed change threshold button")
        
        let pointSelectionViewController = storyboard?.instantiateViewController(withIdentifier: "pointSelecitonViewController") as! PointSelectViewController
        pointSelectionViewController.transitioningDelegate = notifyThresholdAnimator
        present(pointSelectionViewController, animated: true, completion: nil)
    }
    
    @IBAction func openHackerNews(_ sender: AnyObject) {
        webViewInteractor?.animateTransition()
    }
    
    @IBAction func handleSwipe(_ sender: UIPanGestureRecognizer) {
        setCurrentInteractor(sender:sender)
        recentStoriesInteractor?.updateGestureMotion(sender:sender)
        webViewInteractor?.updateGestureMotion(sender:sender)
    }

    func setCurrentInteractor (sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        if translation.x > 0 {
            if let webViewInteractor = webViewInteractor {
                webViewInteractor.cancel()
            }
            
        } else if translation.x < 0 {
            if let recentStoriesInteractor = recentStoriesInteractor {
                recentStoriesInteractor.cancel()
            }
        }
    }
    
    func resetViewLoadingState() {
        topStoriesTable.isHidden = true
        connectionFailedView.isHidden = true
        thesholdTooLowView.isHidden = true
        topStoriesTableWrapper.isHidden = true
        loadingIndicator.startAnimating()
        CATransaction.flush()
    }
    
    func updateFinishedView() {
        loadingIndicator.stopAnimating()
        CATransaction.flush()
    }
    
    func displayFailedToLoad() {
        
        connectionFailedView.isHidden = false
        topStoriesTable.isHidden = true
        thesholdTooLowView.isHidden = true
        
        updateFinishedView()
        
    }
    
    func displayStories() {
        
        topStoriesTableWrapper.isHidden = false
        thesholdTooLowView.isHidden = true
        connectionFailedView.isHidden = true
        topStoriesTable.isHidden = false
        
        updateFinishedView()
        
        DispatchQueue.main.async {
            self.topStoriesTable.reloadData()
        }
    }
    
    func eitherDisplayTooFewStoriesOrShowTableView() {
        
        if (filteredStories!.count == 0) {
            
            topStoriesTableWrapper.isHidden = false
            topStoriesTable.isHidden = true
            connectionFailedView.isHidden = true
            thesholdTooLowView.isHidden = false
            
            updateFinishedView()
            
        } else {
            // show the top stories
            topStoriesTable.isHidden = false
        }
    }
}

extension HomeViewController: HttpStoriesListener {

    func onStoriesLoaded(stories: [Story]) {
        self.stories = stories
        displayStories()
    }
    
    func onStoriesLoadedError(error: Error) {
        displayFailedToLoad()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
        if ((self.stories != nil) && (self.stories?.count)! > 0) {
            let currentStories = self.stories!
            
            filteredStories = currentStories.filter({$0.meetsThreshold(threshold: pointRetainer.value)})
            eitherDisplayTooFewStoriesOrShowTableView()
            return filteredStories!.count
        }
        filteredStories = nil
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let story = filteredStories?[(indexPath as NSIndexPath).row]
        return HackPopStyle.GetStyledStoryCell(story!)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Flurry.logEvent("opened story from home view stories")
        let story = filteredStories?[(indexPath as NSIndexPath).row]
        Story.current = story
        webViewInteractor?.animateTransition()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
}

extension HomeViewController: HttpSetThresholdListener {
    func onThresholdSet(threshold: Int) {
        pointRetainer.value = threshold
        viewDidLoad()
    }
    
    func onThresholdSetFailed(error: Error?, threshold: Int) {
        if let error = error {
            let alert = HackPopStyle.CreateAlertMessage(title: "Could Not Set Points Theshold",
                                                        message: "If you are not connected to the internet please try again with an internet connection.")
            
            AppDelegate.delay(delay: 0.4) {
                self.present(alert, animated:false, completion: {
                    self.pointRetainer.value = threshold
                    self.viewDidLoad()
                })
            }
        }
    }
}


extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (!connectionFailedView.isHidden) {
           hackPopServer.getStories(delegate: self)
           resetViewLoadingState()
        }
    }

}
