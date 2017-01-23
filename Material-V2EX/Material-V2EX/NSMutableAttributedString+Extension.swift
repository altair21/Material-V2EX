//
//  NSMutableAttributedString+Extension.swift
//  Material-V2EX
//
//  Created by altair21 on 17/1/23.
//  Copyright © 2017年 altair21. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    
    static func contentFromHTMLString(_ content: String, fontName: String, widthConstraint: CGFloat) -> NSMutableAttributedString? {
        let htmlData = content.data(using: .unicode, allowLossyConversion: true)!
        let attributedString = try? NSMutableAttributedString(data: htmlData, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
        let totalRange = NSRange(location: 0, length: (attributedString?.length)!)
        
        attributedString?.enumerateAttribute(NSFontAttributeName, in: totalRange, options: .longestEffectiveRangeNotRequired, using: { (value, range, _) in
            let font = value as! UIFont
            let newFont = UIFont(name: fontName, size: font.pointSize + 2)!
            attributedString?.addAttributes([NSFontAttributeName: newFont], range: range)
        })
        attributedString?.enumerateAttribute(NSAttachmentAttributeName, in: totalRange, options: .init(rawValue: 0), using: { (value, range, _) in
            if let attachment = value as? NSTextAttachment {
                let image = attachment.image(forBounds: attachment.bounds, textContainer: NSTextContainer(), characterIndex: range.location)
                if (image?.size.width)! > widthConstraint {
                    let newImage = image?.resize(toWidth: widthConstraint - 2 / (image?.size.width)!)
                    let newAttribute = NSTextAttachment()
                    newAttribute.image = newImage
                    attributedString?.addAttribute(NSAttachmentAttributeName, value: newAttribute, range: range)
                }
            }
        })
        if (attributedString?.mutableString.length)! > 0 {
            attributedString?.replaceCharacters(in: NSRange(location: (attributedString?.length)! - 1, length: 1), with: NSAttributedString(string: ""))    // 删除最后的换行符
        }
        
        return attributedString
    }

}
