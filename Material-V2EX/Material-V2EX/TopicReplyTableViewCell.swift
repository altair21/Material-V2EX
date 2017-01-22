//
//  TopicReplyTableViewCell.swift
//  Material-V2EX
//
//  Created by altair21 on 17/1/3.
//  Copyright © 2017年 altair21. All rights reserved.
//

import UIKit
import Material

class TopicReplyTableViewCell: UITableViewCell {
    // UI
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var thanksLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    // Data
    var data: TopicReplyModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setData(data: TopicReplyModel) {
        self.data = data
        
        avatarView.setImageWith(string: (data.author.avatarURL))
        nameLabel.text = data.author.username
        dateLabel.text = data.date
        thanksLabel.text = data.thanks
        
        let htmlData = data.content.data(using: .unicode)!
        let attributedString = try? NSMutableAttributedString(data: htmlData, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
        attributedString?.enumerateAttribute(NSFontAttributeName, in: NSRange(location: 0, length: (attributedString?.length)!), options: .longestEffectiveRangeNotRequired, using: { (value, range, _) in
            let font = value as! UIFont
            let newFont = UIFont(name: contentTextView.font!.fontName, size: font.pointSize + 2)!
            attributedString?.addAttributes([NSFontAttributeName: newFont], range: range)
        })
        attributedString?.enumerateAttribute(NSLinkAttributeName, in: NSRange(location: 0, length: (attributedString?.length)!), options: .longestEffectiveRangeNotRequired, using: { (value, range, _) in
            print(value)
        })
        attributedString?.replaceCharacters(in: NSRange(location: (attributedString?.length)! - 1, length: 1), with: NSAttributedString(string: ""))    // 删除最后的换行符
        contentTextView.layer.shouldRasterize = true
        contentTextView.layer.rasterizationScale = UIScreen.main.scale
        contentTextView.attributedText = attributedString
    }

}
