//
//  PointSelectionAnimationController.swift
//  hack pop
//
//  Created by Jamie Sunderland on 9/16/16.
//  Copyright © 2016 james inc. All rights reserved.
//

import UIKit
import Foundation

class PointSelectionAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    enum HomeViewControllerContainers: Int {
        // set the index at 1
        case TitleContainer = 1, NotifyThresholdContainer, TopStoriesContainer, Background
    }
    
    enum PointSelectionViewControllerContainers: Int {
        // set the index at 1
        case NotifyThresholdContainer = 1
    }


    var originFrame = CGRect.zero
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 20.0
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        // 1
        guard let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let containerView = transitionContext.containerView(),
            let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
            let notifyThresholdView = fromViewController.view?.viewWithTag(HomeViewControllerContainers.NotifyThresholdContainer.rawValue),
            let backgroundView = fromViewController.view?.viewWithTag(HomeViewControllerContainers.Background.rawValue),
            let titleView = fromViewController.view?.viewWithTag(HomeViewControllerContainers.TitleContainer.rawValue),
            let topStoriesView = fromViewController.view?.viewWithTag(HomeViewControllerContainers.TopStoriesContainer.rawValue),
            let notifyThresholdPointSelectionView = toViewController.view?.viewWithTag(PointSelectionViewControllerContainers.NotifyThresholdContainer.rawValue)
        
        else {
                return
        }
        
        let finalFrameForVC = transitionContext.finalFrameForViewController(toViewController)
        //containerView.addSubview(toViewController.view)
        //containerView.sendSubviewToBack(toViewController.view)
        //fromViewController.view.removeFromSuperview()
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            let notifcationDeltaY = notifyThresholdView.frame.origin.y - notifyThresholdPointSelectionView.frame.origin.y
            notifyThresholdView.frame = notifyThresholdPointSelectionView.frame
            titleView.frame.origin.y -= notifcationDeltaY
            }, completion: {
                finished in
                containerView.addSubview(toViewController.view)
                transitionContext.completeTransition(true)
        })
    }
}
