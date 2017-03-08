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
    
    // new model
    var topicModel: TopicModel? = nil {
        didSet {
            if let model = topicModel {
                let index = overviewData.href.index(before: overviewData.href.endIndex)
                model.basicHref = overviewData.href.substring(to: index)
            }
            self.tableView.reloadData()
        }
    }
    
    // old model
    var overviewData: TopicOverviewModel!
    
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
        if let model = topicModel {
            if model.replies.count > 0 {
                var cnt = 4 // 标题、正文、回复数cell、底部空白
                if model.totalPages > model.page {
                    cnt += 1    // BlankCell（转菊）
                }
                return model.replies.count + model.subtleContent.count + cnt
            } else {
                return model.subtleContent.count + 4    // 标题、正文、BlankCell、底部空白
            }
        }
        return 3    // 标题、转菊、底部空白
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 { // 首行始终是标题
            let cell = tableView.dequeueReusableCell(withIdentifier: Global.Cells.topicHeaderCell, for: indexPath) as! TopicHeaderTableViewCell
            cell.titleLabel.text = overviewData.title
            return cell
        }
        
        if let topicModel = self.topicModel {  // 已有数据
            if indexPath.row == 1 { // 有数据时第二行始终是正文
                let cell = tableView.dequeueReusableCell(withIdentifier: Global.Cells.topicAuthorCell, for: indexPath) as! TopicAuthorTableViewCell
                cell.setData(overview: overviewData, data: topicModel)
                return cell
            } else if indexPath.row < topicModel.subtleContent.count + 2 {  // 有数据时始终是追加内容
                let cell = tableView.dequeueReusableCell(withIdentifier: Global.Cells.topicSubtleCell, for: indexPath) as! TopicSubtleTableViewCell
                cell.setData(data: topicModel.subtleContent[indexPath.row - 2])
                return cell
            }
            if topicModel.replies.count > 0 {   // 有回复
                var cnt = 3 // 标题、正文、回复数cell
                if topicModel.totalPages > topicModel.page {
                    cnt += 1
                    if indexPath.row == topicModel.subtleContent.count + topicModel.replies.count + 3 { // BlankCell
                        let cell = tableView.dequeueReusableCell(withIdentifier: Global.Cells.topicBlankCell, for: indexPath) as! BlankTableViewCell
                        cell.state = .refreshing
                        NetworkManager.shared.getTopicDetailComments(url: topicModel.basicHref + "\(topicModel.page + 1)", success: { (res) in
                            topicModel.replies += res
                            topicModel.page += 1
                            self.tableView.reloadData()
                        }, failure: { (error) in
                            print(error)
                            
                            // TODO: failure toast
                        })
                        return cell
                    }
                }
                if indexPath.row == topicModel.subtleContent.count + topicModel.replies.count + cnt {  // FooterCell
                    let cell = tableView.dequeueReusableCell(withIdentifier: Global.Cells.topicFooterCell, for: indexPath)
                    return cell
                } else if indexPath.row == topicModel.subtleContent.count + 2 { // 回复数cell
                    let cell = tableView.dequeueReusableCell(withIdentifier: Global.Cells.topicReplyCountCell, for: indexPath) as! TopicReplyCountTableViewCell
                    cell.replyCountLabel.text = topicModel.totalReplies
                    return cell
                } else {    // 回复cell
                    let cell = tableView.dequeueReusableCell(withIdentifier: Global.Cells.topicReplyCell, for: indexPath) as! TopicReplyTableViewCell
                    cell.setData(data: topicModel.replies[indexPath.row - topicModel.subtleContent.count - 3])
                    return cell
                }
            } else {    // 无回复
                if indexPath.row == topicModel.subtleContent.count + 2 {    // BlankCell
                    let cell = tableView.dequeueReusableCell(withIdentifier: Global.Cells.topicBlankCell, for: indexPath) as! BlankTableViewCell
                    cell.state = .finish
                    cell.placeholder.text = Global.Constants.PlaceHolder.noReply
                    return cell
                } else {    // FooterCell
                    let cell = tableView.dequeueReusableCell(withIdentifier: Global.Cells.topicFooterCell, for: indexPath)
                    return cell
                }
            }
        } else {    // 正在请求数据
            if indexPath.row == 1 { // 第二行是 BlankCell
                let cell = tableView.dequeueReusableCell(withIdentifier: Global.Cells.topicBlankCell, for: indexPath) as! BlankTableViewCell
                cell.state = .refreshing
                return cell
            } else {    // 最后一行是 FooterCell
                let cell = tableView.dequeueReusableCell(withIdentifier: Global.Cells.topicFooterCell, for: indexPath)
                return cell
            }
        }
        
    }
}
