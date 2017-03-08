//
//  BlankTableViewCell.swift
//  Material-V2EX
//
//  Created by altair21 on 17/1/3.
//  Copyright © 2017年 altair21. All rights reserved.
//

import UIKit

class BlankTableViewCell: UITableViewCell {
    @IBOutlet weak var indicator: ARIndicator!
    @IBOutlet weak var placeholder: UILabel!
    @IBOutlet weak var baseLine: UIView!
    
    enum BlankCellState {
        case refreshing
        case finish
    }
    
    var state: BlankCellState = .finish {
        didSet {
            switch state {
            case .refreshing:
                placeholder.isHidden = true
                indicator.isHidden = false
                baseLine.isHidden = true
            case .finish:
                placeholder.isHidden = false
                indicator.isHidden = true
                baseLine.isHidden = false
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        indicator.firstColor = UIColor.fromHex(string: "#1B9AAA")
        indicator.secondColor = UIColor.fromHex(string: "#06D6A0")
        indicator.thirdColor = UIColor.fromHex(string: "#E84855")
        indicator.state = .running
    }

}
