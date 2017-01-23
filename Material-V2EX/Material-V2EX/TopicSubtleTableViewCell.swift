//
//  TopicSubtleTableViewCell.swift
//  Material-V2EX
//
//  Created by altair21 on 17/1/22.
//  Copyright © 2017年 altair21. All rights reserved.
//

import UIKit

class TopicSubtleTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data: (content: String, date: String)) {
        dateLabel.text = data.date
        
        let htmlData = data.content.data(using: .unicode)!
        let attributedString = try? NSMutableAttributedString(data: htmlData, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
        attributedString?.enumerateAttribute(NSFontAttributeName, in: NSRange(location: 0, length: (attributedString?.length)!), options: .longestEffectiveRangeNotRequired, using: { (value, range, _) in
            let font = value as! UIFont
            let newFont = UIFont(name: contentLabel.font!.fontName, size: font.pointSize + 2)!
            attributedString?.addAttributes([NSFontAttributeName: newFont], range: range)
        })
        if (attributedString?.mutableString.length)! > 0 {
            attributedString?.replaceCharacters(in: NSRange(location: (attributedString?.length)! - 1, length: 1), with: NSAttributedString(string: ""))    // 删除最后的换行符
        }
        contentLabel.layer.shouldRasterize = true
        contentLabel.layer.rasterizationScale = UIScreen.main.scale
        contentLabel.attributedText = attributedString
    }

}
