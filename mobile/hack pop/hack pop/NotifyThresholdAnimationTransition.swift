//
//  NotifyThresholdAnimationTransition.swift
//  hack pop
//
//  Created by Jamie Sunderland on 9/24/16.
//  Copyright © 2016 james inc. All rights reserved.
//

import UIKit

enum PointSelectionAnimationState {
    case open
    case close
}

class NotifyThresholdAnimationTransition:  NSObject, UIViewControllerAnimatedTransitioning {
    
    var homeViewController:HomeViewController? = nil
    var pointSelectionViewController:PointSelectViewController? = nil
    var containerView:UIView? = nil
    
    public var presenting:PointSelectionAnimationState = .open
    
    func animationControllerForPresentedController(presented: UIViewController!, presentingController presenting: UIViewController!, sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        return self
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval  {
        return 0.4
    }
    
    func createTransitionContext(homeViewTransitionKey: UITransitionContextViewControllerKey, pointSelectionTransitionKey: UITransitionContextViewControllerKey, transitionContext: UIViewControllerContextTransitioning) {
        homeViewController = transitionContext.viewController(forKey: homeViewTransitionKey) as! HomeViewController?
        pointSelectionViewController = transitionContext.viewController(forKey: pointSelectionTransitionKey) as! PointSelectViewController?
        containerView = transitionContext.containerView
    
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch presenting {
        case .open:
            open(using: transitionContext)
        case .close:
            close(using: transitionContext)
        }
    }
    
    func setHomeControllerClosedState(homeViewController:HomeViewController, pointSelectionViewController:PointSelectViewController) {
        homeViewController.notifyThresholdContainer.frame = pointSelectionViewController.notifyThresholdView!.frame
        homeViewController.topStoriesContainer.frame.origin.y = homeViewController.view.frame.size.height
        homeViewController.titleViewContainer.frame.origin.y = -(homeViewController.titleViewContainer.frame.size.height )
    }
    
    func open(using transitionContext: UIViewControllerContextTransitioning) {
        
        createTransitionContext(homeViewTransitionKey:UITransitionContextViewControllerKey.from,
                                pointSelectionTransitionKey:UITransitionContextViewControllerKey.to,
                                transitionContext:transitionContext)
        
        // add new view controller to view controller
        if let pointSelectionViewController = pointSelectionViewController,
            let homeViewController = homeViewController,
            let containerView = containerView {
            
            pointSelectionViewController.view.isHidden = true
            containerView.addSubview((pointSelectionViewController.view)!)
            CATransaction.flush()
            
            UIView.animateKeyframes(
                withDuration: transitionDuration(using: transitionContext),
                delay: 0,
                options: .calculationModeCubic,
                animations: {
                    self.setHomeControllerClosedState(homeViewController: homeViewController, pointSelectionViewController: pointSelectionViewController)
                }, completion: { finished in
                    pointSelectionViewController.view.isHidden = false
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
    
    func close(using transitionContext: UIViewControllerContextTransitioning) {
        
        createTransitionContext(homeViewTransitionKey:UITransitionContextViewControllerKey.to,
                                pointSelectionTransitionKey:UITransitionContextViewControllerKey.from,
                                transitionContext:transitionContext)
        
        if let pointSelectionViewController = pointSelectionViewController,
            let homeViewController = homeViewController,
            let containerView = containerView {
                        
            homeViewController.view.isHidden = true
            containerView.addSubview(homeViewController.view)
            CATransaction.flush()
            
            let finalTitleViewFrame = homeViewController.titleViewContainer.frame
            let finalNotifyContainerFrame = homeViewController.notifyThresholdContainer.frame
            let finalTopStoriesContainerFrame = homeViewController.topStoriesContainer.frame
            
            setHomeControllerClosedState(homeViewController: homeViewController, pointSelectionViewController: pointSelectionViewController)
            pointSelectionViewController.view.isHidden = true
            homeViewController.view.isHidden = false
            
            UIView.animateKeyframes(
                withDuration: transitionDuration(using: transitionContext),
                delay: 0,
                options: .calculationModeCubic,
                animations: {
                    homeViewController.titleViewContainer.frame = finalTitleViewFrame
                    homeViewController.notifyThresholdContainer.frame = finalNotifyContainerFrame
                    homeViewController.topStoriesContainer.frame = finalTopStoriesContainerFrame
                }, completion: { finished in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
}

extension NotifyThresholdAnimationTransition: UIViewControllerTransitioningDelegate {
    
    func animationControllerForDismissedController(dismissed: UIViewController!) -> UIViewControllerAnimatedTransitioning!  {
        return self
    }

    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
}

