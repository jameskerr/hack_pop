//
//  DimissAnimator.swift
//  hack pop
//
//  Created by Jamie Sunderland on 10/5/16.
//  Copyright © 2016 james inc. All rights reserved.
//

import UIKit

class DismissAnimator: NSObject {

}

extension DismissAnimator : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let containerView:UIView? = transitionContext.containerView
            else {
                return
        }
        
        toVC.view.frame.origin.x = -(toVC.view.frame.size.width)
        containerView?.addSubview(toVC.view)
        
        let screenBounds = UIScreen.main.bounds
        let bottomLeftCorner = CGPoint(x: screenBounds.width*0.5, y: 0)
        let finalFrame = CGRect(origin: bottomLeftCorner, size: screenBounds.size)
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
