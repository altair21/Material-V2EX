//
//  PaddingLabel.swift
//  Material-V2EX
//
//  Created by altair21 on 16/12/24.
//  Copyright © 2016年 altair21. All rights reserved.
//

import UIKit

class PaddingLabel: UILabel
{
    let topInset = CGFloat(0)
    let bottomInset = CGFloat(0)
    let leftInset = CGFloat(5)
    let rightInset = CGFloat(5)
    
    override func drawText(in rect: CGRect)
    {
        let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override public var intrinsicContentSize: CGSize
    {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
}
