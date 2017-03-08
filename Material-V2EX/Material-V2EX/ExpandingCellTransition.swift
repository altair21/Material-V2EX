//
//  ExpandingCellTransition.swift
//  Material-V2EX
//
//  Created by altair21 on 16/12/26.
//  Copyright © 2016年 altair21. All rights reserved.
//

import UIKit

private let animationDuration = 0.6

protocol ExpandingTransitionPresentingViewController {
    func expandingTransitionTargetView(forTransition transition: ExpandingCellTransition) -> UIView!
}

protocol ExpandingTransitionPresentedViewController {
    func expandingTransition(_ transition: ExpandingCellTransition, navigationBarSnapshot: UIView?)
}

class ExpandingCellTransition: NSObject, UIViewControllerAnimatedTransitioning {
    enum TransitionType {
        case None
        case Presenting
        case Dismissing
    }
    
    enum TransitionState {
        case Initial
        case Final
    }
    
    var type: TransitionType = .None
    var presentingController: UIViewController!
    var presentedController: UIViewController!
    
    var targetSnapshot: UIView!
    var targetContainer: UIView!
    
    var topRegionSnapshot: UIView!
    var bottomRegionSnapshot: UIView!
    var navigationBarSnapshot: UIView? = nil
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let duration = transitionDuration(using: transitionContext)
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let containerView = transitionContext.containerView
    
        var foregroundViewController = toViewController
        var backgroundViewController = fromViewController
        
        if type == .Dismissing {
            foregroundViewController = fromViewController
            backgroundViewController = toViewController
        }
        
        // get target view
        var targetViewController = backgroundViewController
        if let navController = targetViewController as? UINavigationController {
            targetViewController = navController.topViewController!
        }
        let targetViewMaybe = (targetViewController as? ExpandingTransitionPresentingViewController)?.expandingTransitionTargetView(forTransition: self)
        
        assert(targetViewMaybe != nil, "Cannot find target view in background view controller")
        
        let targetView = targetViewMaybe!
        
        // setup animation
        let targetFrame = backgroundViewController.view.convert(targetView.frame, from: targetView.superview)
        if type == .Presenting {
            sliceSnapshotsIn(backgroundViewController: backgroundViewController, targetFrame: targetFrame, targetView: targetView)
            (foregroundViewController as? ExpandingTransitionPresentedViewController)?.expandingTransition(self, navigationBarSnapshot: navigationBarSnapshot)
        } else {
            navigationBarSnapshot?.frame = containerView.convert((navigationBarSnapshot?.frame)!, from: navigationBarSnapshot?.superview)
        }
        
        targetContainer.addSubview(foregroundViewController.view)
        containerView.addSubview(targetContainer)
        containerView.addSubview(topRegionSnapshot)
        containerView.addSubview(bottomRegionSnapshot)
        if navigationBarSnapshot != nil {
            containerView.addSubview(navigationBarSnapshot!)
        }
        
        let width = backgroundViewController.view.bounds.width
        let height = backgroundViewController.view.bounds.height
        
        let preTransition: TransitionState = (type == .Presenting ? .Initial : .Final)
        let postTransition: TransitionState = (type == .Presenting ? .Final : .Initial)
        
        configureViewsTo(state: preTransition, width: width, height: height, targetFrame: targetFrame, fullFrame: foregroundViewController.view.frame, foregroundView: foregroundViewController.view)
        
        // perform animation
        backgroundViewController.view.isHidden = true
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: UIViewAnimationOptions(),
                       animations: { () -> Void in
                        self.configureViewsTo(state: postTransition, width: width, height: height, targetFrame: targetFrame, fullFrame: foregroundViewController.view.frame, foregroundView: foregroundViewController.view)
                        
                        if self.type == .Presenting {
                            self.navigationBarSnapshot?.frame.size.height = 0
                        }
                        
//                        UIApplication.shared.statusBarStyle = (self.type == .Presenting ? .default : .lightContent)
        }, completion: {
            (finished) in
            self.targetContainer.removeFromSuperview()
            self.topRegionSnapshot.removeFromSuperview()
            self.bottomRegionSnapshot.removeFromSuperview()
            self.navigationBarSnapshot?.removeFromSuperview()
            
            foregroundViewController.view.frame.size.height = height
            containerView.addSubview(foregroundViewController.view)
            backgroundViewController.view.isHidden = false
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    func sliceSnapshotsIn(backgroundViewController: UIViewController, targetFrame: CGRect, targetView: UIView) {
        let view = backgroundViewController.view!
        let width = view.bounds.width
        let height = view.bounds.height
        
        topRegionSnapshot = view.resizableSnapshotView(from: CGRect(x: 0, y: 0, width: width, height: targetFrame.minY), afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero)
        
        bottomRegionSnapshot = view.resizableSnapshotView(from: CGRect(x: 0, y: targetFrame.maxY, width: width, height: height - targetFrame.maxY), afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero)
        
        targetSnapshot = targetView.snapshotView(afterScreenUpdates: false)
        targetContainer = UIView(frame: targetFrame)
        targetContainer.backgroundColor = UIColor.fromHex(string: "#EFEFF4")
        targetContainer.clipsToBounds = true
        targetContainer.addSubview(targetSnapshot)
        
        if let navController = backgroundViewController as? UINavigationController {
            let barHeight = navController.navigationBar.frame.maxY
            
            UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: barHeight), false, UIScreen.main.scale)
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
            let navigationBarImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            navigationBarSnapshot = UIImageView(image: navigationBarImage)
            navigationBarSnapshot?.backgroundColor = navController.navigationBar.barTintColor
            navigationBarSnapshot?.contentMode = .bottom
        }
    }
    
    func configureViewsTo(state: TransitionState, width: CGFloat, height: CGFloat, targetFrame: CGRect, fullFrame: CGRect, foregroundView: UIView) {
        switch state {
        case .Initial:
            topRegionSnapshot.frame = CGRect(x: 0, y: 0, width: width, height: targetFrame.minY)
            bottomRegionSnapshot.frame = CGRect(x: 0, y: targetFrame.maxY, width: width, height: height - targetFrame.maxY)
            targetContainer.frame = targetFrame
            targetSnapshot.alpha = 1
            foregroundView.alpha = 0
            navigationBarSnapshot?.sizeToFit()
        case .Final:
            topRegionSnapshot.frame = CGRect(x: 0, y: -targetFrame.minY, width: width, height: targetFrame.minY)
            bottomRegionSnapshot.frame = CGRect(x: 0, y: height, width: width, height: height - targetFrame.maxY)
            targetContainer.frame = fullFrame
            targetSnapshot.alpha = 0
            foregroundView.alpha = 1
        }
    }
}

extension ExpandingCellTransition: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentingController = presenting
        if let navController = presentingController as? UINavigationController {
            presentingController = navController.topViewController
        }
        
        if presentingController is ExpandingTransitionPresentingViewController {
            type = .Presenting
            return self
        } else {
            type = .None
            return nil
        }
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if presentingController is ExpandingTransitionPresentingViewController {
            type = .Dismissing
            return self
        } else {
            type = .None
            return nil
        }
    }
}

