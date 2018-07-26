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
        let attributedString = try? NSMutableAttributedString(data: htmlData, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        let totalRange = NSRange(location: 0, length: (attributedString?.length)!)
        
        attributedString?.enumerateAttribute(NSAttributedStringKey.font, in: totalRange, options: .longestEffectiveRangeNotRequired, using: { (value, range, _) in // 调整字号
            let font = value as! UIFont
            let newFont = UIFont(name: fontName, size: font.pointSize + 2)!
            attributedString?.addAttributes([NSAttributedStringKey.font: newFont], range: range)
        })
        attributedString?.enumerateAttribute(NSAttributedStringKey.attachment, in: totalRange, options: .init(rawValue: 0), using: { (value, range, _) in  // 调整图片尺寸、压缩图片
            if let attachment = value as? NSTextAttachment, let image = attachment.image(forBounds: attachment.bounds, textContainer: NSTextContainer(), characterIndex: range.location) {
                var newImage: UIImage? = nil
                if let imageData = UIImageJPEGRepresentation(image, 0.5) {
                    newImage = UIImage(data: imageData)
                }
                if image.size.width > widthConstraint {
                    newImage = newImage?.resize(toWidth: widthConstraint - 2 / image.size.width) ?? image.resize(toWidth: widthConstraint - 2 / image.size.width)
                }
                if let resultImage = newImage {
                    let newAttribute = NSTextAttachment()
                    newAttribute.image = resultImage
                    attributedString?.addAttribute(NSAttributedStringKey.attachment, value: newAttribute, range: range)
                }
            }
        })
        if (attributedString?.mutableString.length)! > 0 {
            attributedString?.replaceCharacters(in: NSRange(location: (attributedString?.length)! - 1, length: 1), with: NSAttributedString(string: ""))    // 删除最后的换行符
        }
        
        return attributedString
    }

}
