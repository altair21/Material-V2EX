//
//  AnimationUtility.swift
//  Material-V2EX
//
//  Created by altair21 on 16/12/22.
//  Copyright © 2016年 altair21. All rights reserved.
//

import UIKit


fileprivate let animationDuration = 0.3
fileprivate var menuViewPanelOriginX: CGFloat = 0
fileprivate var menuViewBGOriginAlpha: CGFloat = 0
fileprivate var menuViewDisplayed = false
func showMenu(_ menuView: MenuView) {
    menuView.panelViewLeadingConstraint.constant = 0
    menuView.panelView.frame.origin.x = -menuView.panelView.frame.size.width
    
    let keyWindow = UIApplication.shared.keyWindow
    keyWindow?.windowLevel = UIWindowLevelStatusBar + 1
    keyWindow?.addSubview(menuView)
    
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: [], animations: { 
        menuView.bgView.alpha = 1.0
        menuView.panelView.frame.origin.x = 0
    }, completion: nil)
}

func hideMenu(_ menuView: MenuView) {
    UIApplication.shared.isStatusBarHidden = false
    menuView.panelViewLeadingConstraint.constant = -menuView.panelView.frame.size.width
    
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: [], animations: { 
        menuView.bgView.alpha = 0.0
        menuView.panelView.frame.origin.x = -menuView.panelView.frame.size.width
    }, completion: { _ in
        UIApplication.shared.keyWindow?.windowLevel = UIWindowLevelNormal
        menuView.removeFromSuperview()
    })
}

func handleMenu(_ menuView: MenuView, recognizer: UIPanGestureRecognizer) {
    let translation = recognizer.translation(in: recognizer.view)
    var translationX: CGFloat
    if translation.x > 0 {
        translationX = min(translation.x, menuView.panelView.frame.size.width)
    } else {
        translationX = max(translation.x, -menuView.panelView.frame.size.width)
    }
    
    let offsetProgress = translationX / menuView.panelView.frame.size.width
    switch recognizer.state {
    case .began:
        if menuView.superview != nil {
            menuViewPanelOriginX = 0
            menuViewBGOriginAlpha = 1.0
            menuViewDisplayed = true
            return
        }
        menuViewPanelOriginX = -menuView.panelView.frame.size.width
        menuViewBGOriginAlpha = 0.0
        menuViewDisplayed = false
        let keyWindow = UIApplication.shared.keyWindow
        keyWindow?.windowLevel = UIWindowLevelStatusBar + 1
        keyWindow?.addSubview(menuView)
    case .changed:
        menuView.panelView.frame.origin.x = min(max(menuViewPanelOriginX + translationX, -menuView.panelView.frame.size.width), 0)
        menuView.bgView.alpha = min(max(menuViewBGOriginAlpha + offsetProgress, 0.0), 1.0)
    case .cancelled, .ended, .failed:
        if translation.x > 0 && translationX > menuView.panelView.frame.size.width / 2.5 {
            menuViewDisplayed = true
        } else if translation.x < 0 && translationX < -menuView.panelView.frame.size.width / 2.5 {
            menuViewDisplayed = false
        }
        if menuViewDisplayed {
            let restDuration = Double(menuView.panelView.frame.origin.x / menuView.panelView.frame.size.width) * animationDuration
            UIView.animate(withDuration: restDuration, animations: {
                menuView.panelView.frame.origin.x = 0
                menuView.bgView.alpha = 1.0
            }, completion: { _ in
                menuView.panelViewLeadingConstraint.constant = 0
            })
        } else {
            let restDuration = Double((menuView.panelView.frame.origin.x + menuView.panelView.frame.size.width) / menuView.panelView.frame.size.width) * 0.3
            UIView.animate(withDuration: restDuration, animations: {
                menuView.panelView.frame.origin.x = -menuView.panelView.frame.size.width
                menuView.bgView.alpha = 0.0
            }, completion: { _ in
                UIApplication.shared.keyWindow?.windowLevel = UIWindowLevelNormal
                menuView.panelViewLeadingConstraint.constant = -menuView.panelView.frame.size.width
                menuView.removeFromSuperview()
            })
        }
    default:
        break
    }
    
}


