//
//  TopicDetailViewController.swift
//  Material-V2EX
//
//  Created by altair21 on 16/12/26.
//  Copyright © 2016年 altair21. All rights reserved.
//

import UIKit

class TopicDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let transition = ExpandingCellTransition()
    
    var navigationBarSnapshot: UIView!
    var navigationBarHeight: CGFloat = 0
    
    var overviewData: TopicOverviewModel!
    var repliesData: Array<TopicReplyModel>? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        transitioningDelegate = transition
        if navigationBarSnapshot != nil {
            navigationBarSnapshot.frame.origin.y = -navigationBarHeight
        }
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func closeTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: ExpandingTransitionPresentedViewController
extension TopicDetailViewController: ExpandingTransitionPresentedViewController {
    func expandingTransition(_ transition: ExpandingCellTransition, navigationBarSnapshot: UIView) {
        self.navigationBarSnapshot = navigationBarSnapshot
        self.navigationBarHeight = navigationBarSnapshot.frame.height
    }
}

// MARK: UITableViewDataSource & UITableViewDelegate
extension TopicDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let replies = repliesData {
            if replies.count > 0 {
                return replies.count + 3
            } else {
                return 4
            }
        }
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 { // 首行始终是标题
            let cell = tableView.dequeueReusableCell(withIdentifier: Global.Cells.topicHeaderCell, for: indexPath) as! TopicHeaderTableViewCell
            cell.titleLabel.text = overviewData.title
            return cell
        } else if indexPath.row == 1 {  // 第二行始终是作者
            let cell = tableView.dequeueReusableCell(withIdentifier: Global.Cells.topicAuthorCell, for: indexPath) as! TopicAuthorTableViewCell
            cell.setData(data: overviewData)
            return cell
        } else {
            if let replies = repliesData {  // 已有数据
                let footerIndex = (replies.count == 0 ? 3 : replies.count + 2)
                if indexPath.row == footerIndex {  // 最后一行是 FooterCell
                    let cell = tableView.dequeueReusableCell(withIdentifier: Global.Cells.topicFooterCell, for: indexPath)
                    return cell
                } else if replies.count == 0 { // 数据为空（没有回复）
                    let cell = tableView.dequeueReusableCell(withIdentifier: Global.Cells.topicBlankCell, for: indexPath) as! TopicBlankTableViewCell
                    cell.state = .finish
                    return cell
                } else {    // 数据不为空
                    let cell = tableView.dequeueReusableCell(withIdentifier: Global.Cells.topicReplyCell, for: indexPath) as! TopicReplyTableViewCell
                    cell.setData(data: replies[indexPath.row - 2])
                    return cell
                }
            } else {    // 正在请求数据
                if indexPath.row == 2 { // 第三行是 BlankCell
                    let cell = tableView.dequeueReusableCell(withIdentifier: Global.Cells.topicBlankCell, for: indexPath) as! TopicBlankTableViewCell
                    cell.state = .refreshing
                    return cell
                } else {    // 最后一行是 FooterCell
                    let cell = tableView.dequeueReusableCell(withIdentifier: Global.Cells.topicFooterCell, for: indexPath)
                    return cell
                }
            }
        }
    }
}
