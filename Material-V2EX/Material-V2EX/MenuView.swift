//
//  menuView.swift
//  Material-V2EX
//
//  Created by altair21 on 16/12/21.
//  Copyright © 2016年 altair21. All rights reserved.
//

import UIKit

class MenuView: UIView {
    @IBOutlet weak var panelView: UIView!
    @IBOutlet weak var bgView: UIView!
    static let sharedInstance = Bundle.main.loadNibNamed(Global.Views.menuView, owner: nil, options: nil)?.first as! MenuView
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.frame = CGRect(x: 0, y: 0, width: Global.Constants.screenWidth, height: Global.Constants.screenHeight)
        setupGesture()
    }
    
    func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(backHome(sender:)))
        bgView.addGestureRecognizer(tap)
        
        let swipeLeft = UIPanGestureRecognizer(target: self, action: #selector(handlePanel(sender:)))
        self.addGestureRecognizer(swipeLeft)
    }
    
    func backHome(sender: UITapGestureRecognizer) {
        hideMenu(self)
    }
    
    func handlePanel(sender: UIPanGestureRecognizer) {
        handleMenu(self, recognizer: sender)
    }
    
    
    

}
