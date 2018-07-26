//
//  MemberViewController.swift
//  Material-V2EX
//
//  Created by altair21 on 17/3/7.
//  Copyright © 2017年 altair21. All rights reserved.
//

import UIKit
import Material

class MemberViewController: UIViewController {
    @IBOutlet weak var closeButton: FABButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var naviBar: UINavigationBar!
    
    let transition = ExpandingCellTransition()
    var navigationBarSnapshot: UIView?
    var navigationBarHeight: CGFloat = 0
    var selectedIndexPath: IndexPath? = nil
    
    var memberModel: MemberModel? {
        didSet {
            if tableView != nil {
                tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        transitioningDelegate = transition
        if navigationBarSnapshot != nil {
            navigationBarSnapshot!.frame.origin.y = -navigationBarHeight
        }
        tableView.contentInset.top = 10
        tableView.estimatedRowHeight = 140
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.layer.shouldRasterize = true
        tableView.layer.rasterizationScale = UIScreen.main.scale
        
        let tapClose = UITapGestureRecognizer(target: self, action: #selector(closeTapped(sender:)))
        closeButton.addGestureRecognizer(tapClose)
        
        naviBar.setValue(true, forKey: "hidesShadow")
    }
    
    func openTopic(url: String, title: String, indexPath: IndexPath) {
        selectedIndexPath = indexPath
        
        let topicDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Global.ViewControllers.topicDetail) as! TopicDetailViewController
        topicDetailViewController.href = url
        topicDetailViewController.topicTitle = title
        
        NetworkManager.shared.getTopicDetail(url: url, success: { (topicModel) in
            topicDetailViewController.topicModel = topicModel
        }, failure: { (error) in
            print(error)
            // TODO: failure toast
        })
        
        self.present(topicDetailViewController, animated: true, completion: nil)
    }
    
    @objc func closeTapped(sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }

}

// MARK: ExpandingTransitionPresentedViewController
extension MemberViewController: ExpandingTransitionPresentedViewController {
    func expandingTransition(_ transition: ExpandingCellTransition, navigationBarSnapshot: UIView?) {
        self.navigationBarSnapshot = navigationBarSnapshot
        if let naviBar = navigationBarSnapshot {
            self.navigationBarHeight = naviBar.frame.height
        }
    }
}

// MARK: ExpandingTransitionPresentingViewController
extension MemberViewController: ExpandingTransitionPresentingViewController {
    func expandingTransitionTargetView(forTransition transition: ExpandingCellTransition) -> UIView! {
        if let indexPath = selectedIndexPath {
            return tableView.cellForRow(at: indexPath)
        } else {
            return nil
        }
    }
}

// MARK: UITableViewDelegate && UITableViewDataSource
extension MemberViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let memberModel = memberModel {
            let topicSectionCount = memberModel.topics.count > 0 ? (2 + memberModel.topics.count) : 3
            let replySectionCount = memberModel.replies.count > 0 ? (2 + memberModel.replies.count) : 3
            return 1 + topicSectionCount + replySectionCount
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let memberModel = memberModel {
            let topicCountOffset = memberModel.topics.count > 0 ? 0 : 1
            let replyCountOffset = memberModel.replies.count > 0 ? 0 : 1
            let firstFooterCellRow = memberModel.topics.count + 2 + topicCountOffset
            if indexPath.row == 0 { // 第一个是 MainCell
                let cell = tableView.dequeueReusableCell(withIdentifier: Global.Cells.memberMain, for: indexPath) as! MemberMainTableViewCell
                cell.setAvatarUrl(memberModel.avatarURL, name: memberModel.username, joinNumber: memberModel.joinNumber, joinDate: memberModel.joinDate)
                return cell
            } else if indexPath.row == 1 {  // 第二个是 TopicSectionHeader
                let cell = tableView.dequeueReusableCell(withIdentifier: Global.Cells.memberHeader, for: indexPath) as! MemberHeaderTableViewCell
                cell.headerLabel.text = memberModel.username + " 创建的话题"
                return cell
            } else if indexPath.row > 1 && indexPath.row < memberModel.topics.count + 2 {   // 有数据时是创建的话题
                let cell = tableView.dequeueReusableCell(withIdentifier: Global.Cells.memberTopic, for: indexPath) as! MemberTopicTableViewCell
                cell.setData(data: memberModel.topics[indexPath.row - 2], indexPath: indexPath)
                return cell
            } else if indexPath.row == firstFooterCellRow {    // FooterCell
                let cell = tableView.dequeueReusableCell(withIdentifier: Global.Cells.memberFooter, for: indexPath)
                return cell
            } else if indexPath.row == firstFooterCellRow + 1 { // ReplySectionHeader
                let cell = tableView.dequeueReusableCell(withIdentifier: Global.Cells.memberHeader, for: indexPath) as! MemberHeaderTableViewCell
                cell.headerLabel.text = memberModel.username + " 创建的回复"
                return cell
            } else if indexPath.row > firstFooterCellRow + 1 && indexPath.row < memberModel.replies.count + firstFooterCellRow + 2 {    // 有数据时是创建的回复
                let cell = tableView.dequeueReusableCell(withIdentifier: Global.Cells.memberReply, for: indexPath) as! MemberReplyTableViewCell
                cell.setData(data: memberModel.replies[indexPath.row - firstFooterCellRow - 2], indexPath: indexPath)
                return cell
            } else if indexPath.row == memberModel.replies.count + firstFooterCellRow + 2 + replyCountOffset {  // FooterCell
                let cell = tableView.dequeueReusableCell(withIdentifier: Global.Cells.memberFooter, for: indexPath)
                return cell
            }
            else {
                if memberModel.topics.count == 0 && indexPath.row == 2 {
                    if memberModel.isHideTopic {    // 用户隐藏了话题
                        let cell = tableView.dequeueReusableCell(withIdentifier: Global.Cells.memberHideTopic, for: indexPath)
                        return cell
                    } else {    // topicSection blankCell
                        let cell = tableView.dequeueReusableCell(withIdentifier: Global.Cells.memberBlank, for: indexPath) as! BlankTableViewCell
                        cell.state = .finish
                        cell.placeholder.text = Global.Constants.PlaceHolder.noOwnedTopic
                        return cell
                    }
                } else if memberModel.replies.count == 0 && indexPath.row == firstFooterCellRow + 2 {   // replySection blankCell
                    let cell = tableView.dequeueReusableCell(withIdentifier: Global.Cells.memberBlank, for: indexPath) as! BlankTableViewCell
                    cell.state = .finish
                    cell.placeholder.text = Global.Constants.PlaceHolder.noOwnedReply
                    return cell
                } else {
                    // 经过我缜密的计算，不会进入到这个condition，只是为了通过编译
                    return UITableViewCell()
                }
            }
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Global.Cells.memberBlank, for: indexPath) as! BlankTableViewCell
                cell.state = .refreshing
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Global.Cells.memberFooter, for: indexPath)
                return cell
            }
        }
    }
    
}

// MARK: UIScrollViewDelegate
extension MemberViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 根据 offset 改变 navigationBar 阴影
        let newRadius = min(1, max(tableView.contentOffset.y / 180, 0)) * Global.Config.navigationBarMaxShadowRadius
        naviBar.layer.shadowRadius = newRadius
    }
}


