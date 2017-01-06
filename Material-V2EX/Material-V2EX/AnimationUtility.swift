//
//  AnimationUtility.swift
//  Material-V2EX
//
//  Created by altair21 on 16/12/22.
//  Copyright © 2016年 altair21. All rights reserved.
//

import UIKit


fileprivate let animationDuration = 0.3
fileprivate let quickAnimationDuration = animationDuration * 0.5
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
    menuView.panelViewLeadingConstraint.constant = -menuView.panelView.frame.size.width
    
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: [], animations: { 
        menuView.bgView.alpha = 0.0
        menuView.panelView.frame.origin.x = -menuView.panelView.frame.size.width
    }, completion: { _ in
        UIApplication.shared.keyWindow?.windowLevel = UIWindowLevelNormal
        menuView.removeFromSuperview()
    })
}

var menuViewPanelOriginX: CGFloat = 0
var menuViewBGOriginAlpha: CGFloat = 0
var menuViewDisplayed = false

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

func showNodeList(_ nodeListView: NodeListView) {
    nodeListView.panelViewTrailingConstraint.constant = 0
    nodeListView.panelView.frame.origin.x = nodeListView.frame.size.width
    
    let keyWindow = UIApplication.shared.keyWindow
    keyWindow?.windowLevel = UIWindowLevelStatusBar + 1
    keyWindow?.addSubview(nodeListView)
    
    UIView.animate(withDuration: quickAnimationDuration, delay: 0.0, options: [], animations: {
        nodeListView.bgView.alpha = 1.0
        nodeListView.panelView.frame.origin.x = nodeListView.frame.size.width - nodeListView.panelView.frame.size.width
    }, completion: nil)
}

func hideNodeList(_ nodeListView: NodeListView) {
    nodeListView.panelViewTrailingConstraint.constant = -nodeListView.panelView.frame.size.width
    UIView.animate(withDuration: quickAnimationDuration, delay: 0.0, options: [], animations: {
        nodeListView.bgView.alpha = 0.0
        nodeListView.panelView.frame.origin.x = nodeListView.frame.size.width
    }) { (_) in
        UIApplication.shared.keyWindow?.windowLevel = UIWindowLevelNormal
        nodeListView.removeFromSuperview()
    }
}

var nodeListViewPanelOriginX: CGFloat = 0
var nodeListViewBGOriginAlpha: CGFloat = 0
var nodeListViewDisplayed = false

func handleNodeList(_ nodeListView: NodeListView, recognizer: UIPanGestureRecognizer) {
    let translation = recognizer.translation(in: recognizer.view)
    var translationX: CGFloat
    if translation.x > 0 {
        translationX = min(translation.x, nodeListView.panelView.frame.size.width)
    } else {
        translationX = max(translation.x, -nodeListView.panelView.frame.size.width)
    }
    
    let offsetProgress = -translationX / nodeListView.panelView.frame.size.width
    switch recognizer.state {
    case .began:
        if nodeListView.superview != nil {
            nodeListViewPanelOriginX = nodeListView.frame.size.width - nodeListView.panelView.frame.size.width
            nodeListViewBGOriginAlpha = 1.0
            nodeListViewDisplayed = true
            return
        }
        nodeListViewPanelOriginX = nodeListView.frame.size.width
        nodeListViewBGOriginAlpha = 0.0
        nodeListViewDisplayed = false
        let keyWindow = UIApplication.shared.keyWindow
        keyWindow?.windowLevel = UIWindowLevelStatusBar + 1
        keyWindow?.addSubview(nodeListView)
    case .changed:
        nodeListView.panelView.frame.origin.x = min(max(nodeListViewPanelOriginX + translationX, nodeListView.frame.size.width - nodeListView.panelView.frame.size.width), nodeListView.frame.size.width)
        nodeListView.bgView.alpha = min(max(nodeListViewBGOriginAlpha + offsetProgress, 0.0), 1.0)
    case .cancelled, .ended, .failed:
        if translation.x > 0 && translationX > nodeListView.panelView.frame.size.width / 2 {
            nodeListViewDisplayed = false
        } else if translation.x < 0 && translationX < -nodeListView.panelView.frame.size.width / 2 {
            nodeListViewDisplayed = true
        }
        if nodeListViewDisplayed {
            let restDuration = Double(nodeListView.panelView.frame.origin.x - (nodeListView.frame.size.width - nodeListView.panelView.frame.origin.x)) / Double(nodeListView.panelView.frame.size.width) * quickAnimationDuration
            UIView.animate(withDuration: restDuration, animations: { 
                nodeListView.panelView.frame.origin.x = nodeListView.frame.size.width - nodeListView.panelView.frame.size.width
                nodeListView.bgView.alpha = 1.0
            }, completion: { _ in
                nodeListView.panelViewTrailingConstraint.constant = 0
            })
        } else {
            let restDuration = Double(nodeListView.frame.size.width - nodeListView.panelView.frame.origin.x) / Double(nodeListView.panelView.frame.size.width) * quickAnimationDuration
            UIView.animate(withDuration: restDuration, animations: { 
                nodeListView.panelView.frame.origin.x = nodeListView.frame.size.width
                nodeListView.bgView.alpha = 0.0
            }, completion: { _ in
                UIApplication.shared.keyWindow?.windowLevel = UIWindowLevelNormal
                nodeListView.panelViewTrailingConstraint.constant = -nodeListView.panelView.frame.size.width
                nodeListView.removeFromSuperview()
            })
        }
        
    default:
        break
    }
}


