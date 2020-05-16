//
//  SlideUpTransition.swift
//  DocsInOne
//
//  Created by Devesh Tyagi on 14/05/20.
//  Copyright © 2020 deveshtyagi7. All rights reserved.
//

import UIKit
class SlideUpTransition: NSObject, UIViewControllerAnimatedTransitioning {

    var isPresenting = false
    let dimmingView = UIView()

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from) else { return }

        let containerView = transitionContext.containerView

        let finalWidth = toViewController.view.bounds.width
        let finalHeight = CGFloat(269)
        let viewHeight = toViewController.view.bounds.height

        if isPresenting {
            // Add dimming view
            dimmingView.backgroundColor = .black
            dimmingView.alpha = 0.0
            containerView.addSubview(dimmingView)
           
            
            dimmingView.frame = containerView.bounds
            // Add menu view controller to container
            toViewController.view.layer.cornerRadius = 30
            containerView.addSubview(toViewController.view)

            // Init frame off the screen
            toViewController.view.frame = CGRect(x: 0, y: viewHeight, width: finalWidth, height: finalHeight)
        }

        // Move on screen
        let transform = {
            self.dimmingView.alpha = 0.5
            toViewController.view.transform = CGAffineTransform(translationX: 0, y: -finalHeight)
             
        }


        // Move back off screen
        let identity = {
            self.dimmingView.alpha = 0.0
            fromViewController.view.transform = .identity
        }

        // Animation of the transition
        let duration = transitionDuration(using: transitionContext)
        let isCancelled = transitionContext.transitionWasCancelled
        UIView.animate(withDuration: duration, animations: {
            self.isPresenting ? transform() : identity()
        }) { (_) in
            transitionContext.completeTransition(!isCancelled)
        }
    }
    

}
