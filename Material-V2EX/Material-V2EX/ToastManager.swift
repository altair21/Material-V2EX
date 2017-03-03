//
//  ToastManager.swift
//  Material-V2EX
//
//  Created by altair21 on 17/3/2.
//  Copyright © 2017年 altair21. All rights reserved.
//

import UIKit
import MBProgressHUD

class ToastManager: NSObject {
    static let shared = ToastManager()
    
    enum ToastPosition {
        case center
        case bottom
    }
    
    func showToast(toView targetView: UIView, text: String, position: ToastPosition = .center, mode: MBProgressHUDMode = .text) -> MBProgressHUD {
        let toast = MBProgressHUD.showAdded(to: targetView, animated: true)
        toast.bezelView.color = UIColor.black
        toast.contentColor = UIColor.white
        toast.mode = mode
        if position == .bottom {
            toast.offset = CGPoint(x: 0.0, y: MBProgressMaxOffset)
        }
        toast.label.text = text
        toast.hide(animated: true, afterDelay: Global.Config.toastDuration)
        return toast
    }
    
    func showCustomToast(toView targetView: UIView, text: String, position: ToastPosition = .center, customView: UIView) -> MBProgressHUD {
        let toast = MBProgressHUD.showAdded(to: targetView, animated: true)
        toast.mode = .customView
        toast.bezelView.color = UIColor.black
        toast.contentColor = UIColor.white
        toast.customView = customView
        toast.label.text = text
        toast.hide(animated: true, afterDelay: Global.Config.toastDuration)
        return toast
    }
}
