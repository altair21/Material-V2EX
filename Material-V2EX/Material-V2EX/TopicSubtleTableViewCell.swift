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
        contentLabel.text = data.content
    }

}
