//
//  NodeListView.swift
//  Material-V2EX
//
//  Created by altair21 on 17/1/5.
//  Copyright © 2017年 altair21. All rights reserved.
//

import UIKit

protocol SelectNodeDelegate: class {
    func didSelectNode(node: NodeModel)
}

class NodeListView: UIView {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var panelView: UIView!
    @IBOutlet weak var panelViewTrailingConstraint: NSLayoutConstraint!
    var tableView: UITableView!
    
    static let shared = Bundle.main.loadNibNamed(Global.Views.nodeListView, owner: nil, options: nil)?.first as! NodeListView
    weak var delegate: SelectNodeDelegate? = nil
    var selectedIndexPath = IndexPath(row: V2EX.basicCategory.index {$0 == Global.Config.startNode} ?? 0, section: 0) // 初始选中配置中的初始节点，没有设置则选中第一条
    var categoryArray = V2EX.basicCategory
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.frame = CGRect(x: 0, y: 0, width: Global.Constants.screenWidth, height: Global.Constants.screenHeight)
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: panelView.frame.size.width, height: Global.Constants.screenHeight), style: .plain)
        let footerView = UIView()
        tableView.tableFooterView = footerView
        tableView.isOpaque = false
        tableView.register(UINib(nibName: Global.Views.nodeListTableViewCell, bundle: nil), forCellReuseIdentifier: Global.Cells.nodeListCell)
        tableView.delegate = self
        tableView.dataSource = self
        panelView.addSubview(tableView)

        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        tableView.layer.shouldRasterize = true
        tableView.layer.rasterizationScale = UIScreen.main.scale
        
        DispatchQueue.main.async {
            self.tableView.separatorStyle = .none
            self.tableView.backgroundColor = UIColor.fromHex(string: "#FF9B71")
            footerView.backgroundColor = UIColor.fromHex(string: "#FF9B71")
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loginStatusChangedHandler(notification:)),
                                               name: Global.Notifications.kLoginStatusChanged,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(unitNodeSelectHandler(notification:)),
                                               name: Global.Notifications.kUnitNodeSelectChanged,
                                               object: nil)
        
        loginStatusChanged()
        setupGesture()
    }
    
    func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(backHome(sender:)))
        bgView.addGestureRecognizer(tap)
        
        let swipeRight = UIPanGestureRecognizer(target: self, action: #selector(handlePanel(sender:)))
        self.addGestureRecognizer(swipeRight)
    }
    
    @objc func backHome(sender: UITapGestureRecognizer) {
        hideNodeList(self)
    }
    
    @objc func handlePanel(sender: UIPanGestureRecognizer) {
        handleNodeList(self, recognizer: sender)
    }
    
    @objc func loginStatusChangedHandler(notification: Notification) {
        loginStatusChanged()
    }
    
    @objc func unitNodeSelectHandler(notification: Notification) {
        (tableView.cellForRow(at: selectedIndexPath) as! NodeListTableViewCell).configureState(.unselected)
    }
    
    func loginStatusChanged() {
        if User.shared.isLogin {
            categoryArray = V2EX.basicCategory + V2EX.personalCategory
        } else {
            categoryArray = V2EX.basicCategory
        }
        tableView.reloadData()
    }

}

extension NodeListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Global.Cells.nodeListCell, for: indexPath) as! NodeListTableViewCell
        if indexPath.row < V2EX.basicCategory.count {
            cell.nodeButton.title = V2EX.basicCategory[indexPath.row].name
        } else {
            cell.nodeButton.title = V2EX.personalCategory[indexPath.row - V2EX.basicCategory.count].name
        }
        cell.indexPath = indexPath
        cell.tableView = tableView
        if indexPath == selectedIndexPath {
            cell.configureState(.selected)
        } else {
            cell.configureState(.unselected)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < V2EX.basicCategory.count {
            delegate?.didSelectNode(node: V2EX.basicCategory[indexPath.row])
        } else {
            delegate?.didSelectNode(node: V2EX.personalCategory[indexPath.row - V2EX.basicCategory.count])
        }
        (tableView.cellForRow(at: selectedIndexPath) as! NodeListTableViewCell).configureState(.unselected)
        (tableView.cellForRow(at: indexPath) as! NodeListTableViewCell).configureState(.selected)
        self.selectedIndexPath = indexPath
        
        hideNodeList(self)
    }
}
