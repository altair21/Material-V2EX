//
//  Global.swift
//  Material-V2EX
//
//  Created by altair21 on 16/12/21.
//  Copyright © 2016年 altair21. All rights reserved.
//

import UIKit

func delay(seconds: Double, completion: @escaping ()-> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}

class Global: NSObject {
    // ViewControllers
    struct ViewControllers {
        static let menuView = "MenuViewController"
        static let topicDetail = "TopicDetailViewController"
    }
    
    // Views
    struct Views {
        static let menuView = "MenuView"
    }
    
    // Cells
    struct Cells {
        static let topicOverview = "topicOverviewCell"
    }
    
    // Constant
    struct Constants {
        static let screenWidth = UIScreen.main.bounds.width
        static let screenHeight = UIScreen.main.bounds.height
        static let edgePanGestureThreshold: CGFloat = 64
    }
}
