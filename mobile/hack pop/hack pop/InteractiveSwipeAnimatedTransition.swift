//
//  SwipeViewControllerAnimatedTransition.swift
//  hack pop
//
//  Created by Jamie Sunderland on 10/3/16.
//  Copyright © 2016 james inc. All rights reserved.
//

import UIKit

enum SwipeDirection {
    case Left
    case Right
}

class InteractiveSwipeAnimatedTransition: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    private var interactive = true
    private var enterPanGesture: UIScreenEdgePanGestureRecognizer!
    private var edgesDirection:UIRectEdge!
    private var destinationIdentifier:String!
    
    init(edgesDirection:UIRectEdge, destinationIdentifier:String) {
        super.init()
        self.edgesDirection = edgesDirection
        self.destinationIdentifier = destinationIdentifier
        
    }

        
    var sourceViewController: UIViewController! {
        didSet {
            self.enterPanGesture = UIScreenEdgePanGestureRecognizer()
            self.enterPanGesture.addTarget(self, action:"handleOnstagePan:")
            self.enterPanGesture.edges = self.edgesDirection
            self.sourceViewController.view.addGestureRecognizer(self.enterPanGesture)
        }
    }
    
    // TODO: We need to complete this method to do something useful
    func handleOnstagePan(_ pan: UIScreenEdgePanGestureRecognizer) {
        
        // how much distance have we panned in reference to the parent view?
        let translation = pan.translation(in: pan.view!)
        
        // do some math to translate this to a percentage based value
        let percentComplete =  translation.x / pan.view!.bounds.width
        
        print(percentComplete)
        
        // now lets deal with different states that the gesture recognizer sends
        switch (pan.state) {
            
        case UIGestureRecognizerState.began:
            // set our interactive flag to true
            self.interactive = true
            sourceViewController.performSegue(withIdentifier: "openRecentStories", sender:self)
            break
            
        case UIGestureRecognizerState.changed:
            
            // update progress of the transition
            //self.updateInteractiveTransition(d)
            self.update(percentComplete)
            break
            
        default: // .Ended, .Cancelled, .Failed ...
            
            // return flag to false and finish the transition
            self.interactive = false
            if (percentComplete > 0.95) {
                self.finish()
            } else {
                self.cancel()
            }
            
        }
    }
    
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        print("HELP")
    }
    
    func animationControllerForPresentedController(presented: UIViewController!, presentingController presenting: UIViewController!, sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        return self
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval  {
        return 10.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let containerView = transitionContext.containerView
        
        toVC?.view.frame.origin.x = -((fromVC?.view.frame.size.width)!)
        containerView.insertSubview((toVC?.view)!, belowSubview: (fromVC?.view)!)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
              toVC?.view.frame = (fromVC?.view.frame)!
              fromVC?.view.frame.origin.x = (toVC?.view.frame.size.width)!
            }, completion: { finished in
                transitionContext.completeTransition(true)
        })
    }

    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactive ? self : nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactive ? self : nil
    }
    
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

