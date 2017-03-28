//
//  TopicDetailViewController.swift
//  Material-V2EX
//
//  Created by altair21 on 16/12/26.
//  Copyright © 2016年 altair21. All rights reserved.
//

import UIKit
import UITableView_FDTemplateLayoutCell

class TopicDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var naviBar: UINavigationBar!
    
    let transition = ExpandingCellTransition()
    
    var navigationBarSnapshot: UIView?
    var navigationBarHeight: CGFloat = 0
    var selectedIndexPath: IndexPath? = nil
    var cellHeightDic = [IndexPath: CGFloat]()
    
    // model
    var topicModel: TopicModel? = nil {
        didSet {
            if let model = topicModel {
                let index = href.index(before: href.endIndex)   // 经过Model处理，url一定是 "xxxx?p=1" 的形式
                model.basicHref = href.substring(to: index)
            }
            self.tableView.reloadData()
        }
    }
    var href = ""
    var topicTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        transitioningDelegate = transition
        if navigationBarSnapshot != nil {
            navigationBarSnapshot!.frame.origin.y = -navigationBarHeight
        }
        tableView.register(TopicAuthorTableViewCell.self, forCellReuseIdentifier: Global.Cells.topicAuthorCell)
        tableView.register(TopicReplyTableViewCell.self, forCellReuseIdentifier: Global.Cells.topicReplyCell)
        tableView.register(TopicSubtleTableViewCell.self, forCellReuseIdentifier: Global.Cells.topicSubtleCell)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openMember(data: MemberModel, indexPath: IndexPath) {
        selectedIndexPath = indexPath
        
        let memberViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Global.ViewControllers.member) as! MemberViewController
        present(memberViewController, animated: true, completion: nil)
        
        data.getDetail(success: { (memberModel) in
            memberViewController.memberModel = memberModel
        }, failure: { (error) in
            print(error)
            //TODO: add toast
        })
    }

    @IBAction func closeTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: ExpandingTransitionPresentedViewController
extension TopicDetailViewController: ExpandingTransitionPresentedViewController {
    func expandingTransition(_ transition: ExpandingCellTransition, navigationBarSnapshot: UIView?) {
        self.navigationBarSnapshot = navigationBarSnapshot
        if let naviBar = navigationBarSnapshot {
            self.navigationBarHeight = naviBar.frame.height
        }
    }
}

// MARK: ExpandingTransitionPresentingViewController
extension TopicDetailViewController: ExpandingTransitionPresentingViewController {
    func expandingTransitionTargetView(forTransition transition: ExpandingCellTransition) -> UIView! {
        if let indexPath = selectedIndexPath {
            return tableView.cellForRow(at: indexPath)
        } else {
            return nil
        }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 { // 首行始终是标题
            return tableView.fd_heightForCell(withIdentifier: Global.Cells.topicHeaderCell, cacheBy: indexPath, configuration: { (cell) in
                (cell as! TopicHeaderTableViewCell).titleLabel.text = self.topicTitle
            })
        }
        
        if let topicModel = self.topicModel {  // 已有数据
            if indexPath.row == 1 { // 有数据时第二行始终是正文
                return cellHeightDic[indexPath] ?? 68
            } else if indexPath.row < topicModel.subtleContent.count + 2 {  // 有数据时始终是追加内容
                return cellHeightDic[indexPath] ?? 39
            }
            if topicModel.replies.count > 0 {   // 有回复
                var cnt = 3 // 标题、正文、回复数cell
                if topicModel.totalPages > topicModel.page {
                    cnt += 1
                    if indexPath.row == topicModel.subtleContent.count + topicModel.replies.count + 3 { // BlankCell
                        return 70
                    }
                }
                if indexPath.row == topicModel.subtleContent.count + topicModel.replies.count + cnt {  // FooterCell
                    return 15
                } else if indexPath.row == topicModel.subtleContent.count + 2 { // 回复数cell
                    return 20
                } else {    // 回复cell
                    return cellHeightDic[indexPath] ?? 68
                }
            } else {    // 无回复
                if indexPath.row == topicModel.subtleContent.count + 2 {    // BlankCell
                    return 70
                } else {    // FooterCell
                    return 15
                }
            }
        } else {    // 正在请求数据
            if indexPath.row == 1 { // 第二行是 BlankCell
                return 70
            } else {    // 最后一行是 FooterCell
                return 15
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 { // 首行始终是标题
            let cell = tableView.dequeueReusableCell(withIdentifier: Global.Cells.topicHeaderCell, for: indexPath) as! TopicHeaderTableViewCell
            cell.titleLabel.text = topicTitle
            return cell
        }
        
        if let topicModel = self.topicModel {  // 已有数据
            if indexPath.row == 1 { // 有数据时第二行始终是正文
                let cell = tableView.dequeueReusableCell(withIdentifier: Global.Cells.topicAuthorCell, for: indexPath) as! TopicAuthorTableViewCell
                cell.setData(data: topicModel, indexPath: indexPath)
                if cell.contentHeightChanged == nil {
                    weak var weakSelf = self
                    cell.contentHeightChanged = { (height) in
                        if let weakSelf = weakSelf,
                            let visibleRows = weakSelf.tableView.indexPathsForVisibleRows {
                            if visibleRows.contains(indexPath) {
                                weakSelf.cellHeightDic[indexPath] = height
                                DispatchQueue.main.async {
                                    weakSelf.tableView.beginUpdates()
                                    weakSelf.tableView.endUpdates()
                                }
                            }
                        }
                    }
                }
                return cell
            } else if indexPath.row < topicModel.subtleContent.count + 2 {  // 有数据时始终是追加内容
                let cell = tableView.dequeueReusableCell(withIdentifier: Global.Cells.topicSubtleCell, for: indexPath) as! TopicSubtleTableViewCell
                cell.setData(data: topicModel.subtleContent[indexPath.row - 2], indexPath: indexPath)
                if cell.contentHeightChanged == nil {
                    weak var weakSelf = self
                    cell.contentHeightChanged = { (height, cb_indexPath) in
                        if (cb_indexPath != indexPath) {
                            return
                        }
                        if let weakSelf = weakSelf,
                            let visibleRows = weakSelf.tableView.indexPathsForVisibleRows {
                            if visibleRows.contains(indexPath) {
                                if weakSelf.cellHeightDic[indexPath] != nil
                                    && height <= weakSelf.cellHeightDic[indexPath]! {
                                    return
                                }
                                weakSelf.cellHeightDic[indexPath] = height
                                DispatchQueue.main.async {
                                    weakSelf.tableView.beginUpdates()
                                    weakSelf.tableView.endUpdates()
                                }
                            }
                        }
                    }
                }
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
                    cell.setData(data: topicModel.replies[indexPath.row - topicModel.subtleContent.count - 3], indexPath: indexPath)
                    if cell.contentHeightChanged == nil {
                        weak var weakSelf = self
                        cell.contentHeightChanged = { (height, cb_indexPath) in
                            if (cb_indexPath != indexPath) {
                                return
                            }
                            if let weakSelf = weakSelf,
                                let visibleRows = weakSelf.tableView.indexPathsForVisibleRows {
                                if visibleRows.contains(indexPath) {
                                    if weakSelf.cellHeightDic[indexPath] != nil
                                        && height <= weakSelf.cellHeightDic[indexPath]! {
                                        return
                                    }
                                    weakSelf.cellHeightDic[indexPath] = height
                                    DispatchQueue.main.async {
                                        weakSelf.tableView.beginUpdates()
                                        weakSelf.tableView.endUpdates()
                                    }
                                }
                            }
                        }
                    }
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

// MARK: UIScrollViewDelegate
extension TopicDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 根据 offset 改变 navigationBar 阴影
        let newRadius = min(1, max(tableView.contentOffset.y / 80, 0)) * Global.Config.navigationBarMaxShadowRadius
        naviBar.layer.shadowRadius = newRadius
        
        // FIXME: 不加这段会导致WKWebView屏幕外的内容无法渲染，当iOS10修复了这个bug就可以把这些代码删了
        tableView.visibleCells.forEach { (cell) in
            if cell is TopicAuthorTableViewCell {
                (cell as! TopicAuthorTableViewCell).webView.setNeedsLayout()
            } else if cell is TopicReplyTableViewCell {
                (cell as! TopicReplyTableViewCell).webView.setNeedsLayout()
            } else if cell is TopicSubtleTableViewCell {
                (cell as! TopicSubtleTableViewCell).webView.setNeedsLayout()
            }
        }
    }
}
