//
//  Interactor.swift
//  hack pop
//
//  Created by Jamie Sunderland on 10/5/16.
//  Copyright © 2016 james inc. All rights reserved.
//

import UIKit

enum Direction: Int {
    case LeftToRight
    case RightToLeft
}

class Interactor: UIPercentDrivenInteractiveTransition {
    
    var hasStarted = false
    var shouldFinish = false
    var delegateViewController:UIViewController!
    var direction:Direction!
    var destinationIdentifier:String!
    var dimissing:Bool!
    var complete:((_ viewController:UIViewController)->Void)? = nil
    
    public var beforeInteractiveTransition:(()->Void)?
    
    
    //dimissing is a little misleading
    init(delegateViewController:UIViewController, dimissing:Bool, destinationIdentifier:String, direction:Direction, complete: ((_ viewController:UIViewController)->Void)?) {
        self.delegateViewController = delegateViewController
        self.dimissing = dimissing
        self.destinationIdentifier = destinationIdentifier
        self.direction = direction
        self.complete = complete
        super.init()
    }
    
    func animateTransition(runBeforeInteractiveTransitionBlock:Bool = false) {
        
        if runBeforeInteractiveTransitionBlock,
        let beforeInteractiveTransition = beforeInteractiveTransition {
           beforeInteractiveTransition()
        }
        
        let destinationViewController = delegateViewController.storyboard?.instantiateViewController(withIdentifier: destinationIdentifier) as UIViewController!
        destinationViewController?.transitioningDelegate = self
        delegateViewController.present(destinationViewController!, animated: true, completion: {
            if destinationViewController != nil && self.complete != nil {
                self.complete!(destinationViewController!)
            }
        })
        
        if !runBeforeInteractiveTransitionBlock {
            finish()
        }
    }
    
    func updateGestureMotion(sender:UIPanGestureRecognizer) {
        let percentThreshold:CGFloat = 0.4
        let velocityTreshold:CGFloat = 1000
        
        // convert y-position to downward pull progress (percentage)
        let translation = sender.translation(in: delegateViewController.view)
        let velocity = sender.velocity(in: delegateViewController.view)
        let horizontalMovement = direction == .LeftToRight
        ? (translation.x / delegateViewController.view.bounds.width)
        : -(translation.x / delegateViewController.view.bounds.width)
        let slideMovement = fmaxf(Float(horizontalMovement), 0.0)
        let slideMovementPercent = fminf(slideMovement, 1.0)
        let progress = CGFloat(slideMovementPercent)
        let absoluteVelocity:CGFloat = abs(velocity.x)
        
        if progress > 0 && !hasStarted {
            self.hasStarted = true
            animateTransition(runBeforeInteractiveTransitionBlock: true)
        }
        
        switch sender.state {
        case .changed:
            self.shouldFinish = progress > percentThreshold
                || absoluteVelocity > velocityTreshold
            self.update(progress)
        case .cancelled:
            self.hasStarted = false
            self.cancel()
        case .ended:
            self.hasStarted = false
            self.shouldFinish
                ? self.finish()
                : self.cancel()
        default:
            break
        }
    }
    
}

extension Interactor: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func setInitialViewState(toViewController:UIViewController) {
        let screenBounds = UIScreen.main.bounds
        let magnitude:CGFloat = dimissing! ? 0.5 : 1
        let scalar:CGFloat = direction == .RightToLeft ? 1 : -1
        let animationVector:CGFloat = magnitude*scalar
        let origin = CGPoint(x: screenBounds.width*animationVector, y: 0)
        toViewController.view.frame.origin = origin
    }
    
    func getFinalViewFrameOfSource(source: UIViewController) -> CGRect {
        let screenBounds = UIScreen.main.bounds
        let magnitude:CGFloat = dimissing! ? 1 : 0.5
        let scalar:CGFloat = direction == .LeftToRight ? 1 : -1
        let animationVector:CGFloat = magnitude*scalar
        let origin = CGPoint(x: screenBounds.width*animationVector, y: 0)
        return CGRect(origin: origin, size: screenBounds.size)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let containerView:UIView? = transitionContext.containerView
            else {
                return
        }
        
        setInitialViewState(toViewController: toVC)
        
        if dimissing! {
            containerView?.insertSubview(toVC.view, belowSubview: fromVC.view)
        } else {
            containerView?.insertSubview(toVC.view, aboveSubview: fromVC.view)
        }
        
        let finalFrame = getFinalViewFrameOfSource(source: fromVC)
        let currentFrame = fromVC.view.frame
        
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                toVC.view.frame = currentFrame
                fromVC.view.frame = finalFrame
            },
            completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)                
            }
        )
    }

}

extension Interactor: UIViewControllerTransitioningDelegate {
    
    func animationControllerForDismissedController(dismissed: UIViewController!) -> UIViewControllerAnimatedTransitioning!  {
        return self
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self
    }
}
