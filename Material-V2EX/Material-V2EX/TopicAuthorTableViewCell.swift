//
//  TopicAuthorTableViewCell.swift
//  Material-V2EX
//
//  Created by altair21 on 17/1/3.
//  Copyright © 2017年 altair21. All rights reserved.
//

import UIKit

class TopicAuthorTableViewCell: UITableViewCell {
    // UI
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nodeLabel: PaddingLabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    // Data
    var data: TopicOverviewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(overview data: TopicOverviewModel, content: String, date: String) {
        self.data = data
        
        nameLabel.text = data.author.username
        avatarView.setImageWith(string: (data.author.avatarURL))
        dateLabel.text = date
        nodeLabel.text = data.nodeTitle
        
        let htmlData = content.data(using: .unicode, allowLossyConversion: true)!
        let attributedString = try? NSMutableAttributedString(data: htmlData, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, ], documentAttributes: nil)
        
        attributedString?.enumerateAttribute(NSFontAttributeName, in: NSRange(location: 0, length: (attributedString?.length)!), options: .longestEffectiveRangeNotRequired, using: { (value, range, _) in
            let font = value as! UIFont
            let newFont = UIFont(name: contentTextView.font!.fontName, size: font.pointSize + 2)!
            attributedString?.addAttributes([NSFontAttributeName: newFont], range: range)
        })
        attributedString?.replaceCharacters(in: NSRange(location: (attributedString?.length)! - 1, length: 1), with: NSAttributedString(string: ""))    // 删除最后的换行符
        contentTextView.layer.shouldRasterize = true
        contentTextView.layer.rasterizationScale = UIScreen.main.scale
        contentTextView.attributedText = attributedString

    }

}
