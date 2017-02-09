//
//  TopicSubtleModel.swift
//  Material-V2EX
//
//  Created by altair21 on 17/2/8.
//  Copyright © 2017年 altair21. All rights reserved.
//

class TopicSubtleModel: NSObject {
    var date = ""
    var content = ""
    var renderContent: NSMutableAttributedString? = nil
    
    init(date: String, content: String) {
        super.init()
        self.date = date
        self.content = content
    }
}
