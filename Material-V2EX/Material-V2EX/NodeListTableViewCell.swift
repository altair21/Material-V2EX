//
//  NodeListTableViewCell.swift
//  Material-V2EX
//
//  Created by altair21 on 17/1/4.
//  Copyright © 2017年 altair21. All rights reserved.
//

import UIKit
import Material

class NodeListTableViewCell: UITableViewCell {
    @IBOutlet weak var nodeButton: FlatButton!

    var tableView: UITableView?
    var indexPath: IndexPath?
    
    enum NodeListCellState {
        case selected
        case unselected
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        nodeButton.layer.shouldRasterize = true
        nodeButton.layer.rasterizationScale = UIScreen.main.scale
    
        let tap = UITapGestureRecognizer(target: self, action: #selector(nodeButtonTapped))
        nodeButton.addGestureRecognizer(tap)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func nodeButtonTapped() {
        if let tableView = self.tableView, let indexPath = self.indexPath {
            tableView.delegate?.tableView!(tableView, didSelectRowAt: indexPath)
        }
    }
    
    func configureState(_ state: NodeListCellState) {
        switch state {
        case .selected:
            DispatchQueue.main.async {
                self.contentView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15)
            }
        case .unselected:
            DispatchQueue.main.async {
                self.contentView.backgroundColor = UIColor.clear
            }
        }
    }
    
}
