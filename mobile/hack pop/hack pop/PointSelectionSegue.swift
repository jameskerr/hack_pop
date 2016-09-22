//
//  PointSelectionSegue.swift
//  hack pop
//
//  Created by Jamie Sunderland on 9/17/16.
//  Copyright © 2016 james inc. All rights reserved.
//

import UIKit

enum SelectionAnimation {
    case openPointSelection
    case closePointSelection
}

class PointSelectionSegue: UIStoryboardSegue {
    
    static let SegueId:String = "pointSelectionAnimationId"
    
    var animationType = SelectionAnimation.openPointSelection;
    let yTitleTopOffset:CGFloat = 20.0
    let animationDuration:TimeInterval = 0.35
    
    enum HomeViewControllerContainers: Int {
        case titleContainer = 1, notifyThresholdContainer, topStoriesContainer
    }
    
    enum PointSelectionViewControllerContainers: Int {
        case notifyThresholdContainer = 1
    }

    override func perform() {
        switch animationType {
        case .openPointSelection:
            open()
        case .closePointSelection:
            close()
        }
    }
    
    func open() {
        let pointSelectionViewController = destination
        let homeViewController = source
        
        // get the view required for the animation
        let containerView: UIView? = homeViewController.view.superview
        pointSelectionViewController.view.isHidden = true
        containerView?.addSubview(pointSelectionViewController.view)
        
        // get the subviews require din the animation
        if  let notifyThresholdView = homeViewController.view.viewWithTag(HomeViewControllerContainers.notifyThresholdContainer.rawValue),
            let titleView = homeViewController.view.viewWithTag(HomeViewControllerContainers.titleContainer.rawValue),
            let topStoriesView  = homeViewController.view.viewWithTag(HomeViewControllerContainers.topStoriesContainer.rawValue),
            let notifyThresholdPointSelectionView = pointSelectionViewController.view.viewWithTag(PointSelectionViewControllerContainers.notifyThresholdContainer.rawValue)
        {
            UIView.animate(withDuration: animationDuration, animations: {
                let finalNotifyThresholdTopOffset:CGFloat = 40
                    let notifcationDeltaY = notifyThresholdView.frame.origin.y - (notifyThresholdPointSelectionView.frame.origin.y - self.yTitleTopOffset)
                    notifyThresholdView.frame.origin.y = finalNotifyThresholdTopOffset
                    topStoriesView.frame.origin.y = homeViewController.view.frame.size.height
                    titleView.frame.origin.y -= notifcationDeltaY
                    titleView.frame.origin.x = notifyThresholdView.frame.origin.x
                    
                }, completion: { finished in
                    
                    let homeVC: UIViewController = self.source
                    let pointSelectionVC: UIViewController = self.destination
                    homeVC.present(pointSelectionVC, animated: false, completion: nil)
                    pointSelectionViewController.view.isHidden = false
            });
        }
    }
    
    func close() {
        
        let homeViewController = destination
        let pointSelectionViewController = source
        
        // get the views required for closing
        let containerView: UIView? = pointSelectionViewController.view.superview
        pointSelectionViewController.view.isHidden = true
        containerView?.addSubview(homeViewController.view)
        
        if  let notifyThresholdView = homeViewController.view.viewWithTag(HomeViewControllerContainers.notifyThresholdContainer.rawValue),
            let titleView = homeViewController.view.viewWithTag(HomeViewControllerContainers.titleContainer.rawValue),
            let topStoriesView  = homeViewController.view.viewWithTag(HomeViewControllerContainers.topStoriesContainer.rawValue),
            let notifyThresholdPointSelectionView = pointSelectionViewController.view.viewWithTag(PointSelectionViewControllerContainers.notifyThresholdContainer.rawValue)
        {
            let finalTitleY = titleView.frame.origin.y
            let finalNotifyY = notifyThresholdView.frame.origin.y
            let finalTopStoriesY = topStoriesView.frame.origin.y

            //set currently animated state
            
            let notifcationDeltaY = notifyThresholdView.frame.origin.y - (notifyThresholdPointSelectionView.frame.origin.y - yTitleTopOffset)
            notifyThresholdView.frame = notifyThresholdPointSelectionView.frame
            topStoriesView.frame.origin.y = homeViewController.view.frame.size.height
            titleView.frame.origin.y -= notifcationDeltaY
            
            UIView.animate(withDuration: animationDuration, animations: {
                    // set animation of home controller to the original state
                    notifyThresholdView.frame.origin.y = finalNotifyY
                    topStoriesView.frame.origin.y = finalTopStoriesY
                    titleView.frame.origin.y = finalTitleY
                
                }, completion: { finished in
                    
                    let homeVC: UIViewController = self.source
                    let pointSelectionVC: UIViewController = self.destination
                    homeVC.present(pointSelectionVC, animated: false, completion: nil)
            })
        }
    }
}
