//
//  ViewController.swift
//  Material-V2EX
//
//  Created by altair21 on 16/12/20.
//  Copyright © 2016年 altair21. All rights reserved.
//

import UIKit
import Material
import AMScrollingNavbar

class HomeViewController: UIViewController {
    // UI
    @IBOutlet weak var postBtn: FabButton!
    @IBOutlet weak var tableView: PullToRefresh!
    @IBOutlet weak var menuBtn: FabButton!
    @IBOutlet weak var moreBtn: FabButton!
    var menuView: MenuView = MenuView.shared
    var nodeListView: NodeListView = NodeListView.shared
    var leftEdgeView: UIView!
    var rightEdgeView: UIView!
    var navController: ScrollingNavigationController!
    let indicator = ARIndicator(firstColor: UIColor.fromHex(string: "#1B9AAA"), secondColor: UIColor.fromHex(string: "#06D6A0"), thirdColor: UIColor.fromHex(string: "#E84855"))
    var footerView: UIView = UIView()
    var footerView_label: UILabel = UILabel()
    var footerView_indicator: ARIndicator = ARIndicator()
    
    // Data
    var topicOverviewArray = Array<TopicOverviewModel>() {
        didSet {
            if topicOverviewArray.count > 0 {
                footerView.isHidden = false
            } else {
                footerView.isHidden = true
            }
        }
    }
    var selectedIndexPath: IndexPath?
    var category = Global.Config.startNode {
        didSet {
            if category.category == .unit { // 可翻页
                footerView_label.isHidden = true
                footerView_indicator.isHidden = false
            } else {    // 不可翻页
                footerView_label.isHidden = false
                footerView_indicator.isHidden = true
            }
        }
    }
    let navigationBarMaxShadowRadius: CGFloat = 8.0
    let cellMarkReadShadowRadius: CGFloat = 0.75
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navigationController = navigationController as? ScrollingNavigationController {
            navController = navigationController
            navigationController.followScrollView(tableView, delay: 50.0)
        }
        self.tableView.pullToRefreshDelegate = self
        self.nodeListView.delegate = self
        
        let fpsLabel = V2FPSLabel(frame: CGRect(x: 0, y: Global.Constants.screenHeight - 40, width: 80, height: 40))
        UIApplication.shared.keyWindow?.addSubview(fpsLabel)
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        setupUI()
        setupGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if topicOverviewArray.isEmpty {
            indicator.state = .running
            self.tableView.isHidden = true
            self.category.loadTopics(success: { (res) in
                self.topicOverviewArray = res
                self.indicator.state = .stopping
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }, failure: { (error) in
                self.indicator.state = .stopping
                self.tableView.isHidden = false
                // TODO: failure toast
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 在此处初始化color，触发PullToRefresh的setupUI事件，确保自动布局已完成
        self.tableView.headerFirstColor = UIColor.fromHex(string: "#1B9AAA")
        self.tableView.headerSecondColor = UIColor.fromHex(string: "#06D6A0")
        self.tableView.headerThirdColor = UIColor.fromHex(string: "#E84855")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupUI() {
        postBtn.image = Icon.add
        menuBtn.image = Icon.cm.menu
        moreBtn.image = Icon.cm.moreHorizontal
        indicator.center = CGPoint(x: Global.Constants.screenWidth / 2, y: Global.Constants.screenHeight / 2)
        view.addSubview(indicator)
        
        footerView = UIView(frame: CGRect(x: 0, y: 0, width: Global.Constants.screenWidth, height: 50))
        footerView_label = UILabel(frame: CGRect(x: 0, y: 10, width: Global.Constants.screenWidth, height: 20))
        footerView_label.font = UIFont.systemFont(ofSize: 12)
        footerView_label.text = "当前节点不支持翻页"
        footerView_label.textAlignment = .center
        footerView_label.textColor = UIColor.fromHex(string: "#777777")
        footerView.addSubview(footerView_label)
        footerView_indicator = ARIndicator(firstColor: UIColor.fromHex(string: "#1B9AAA"), secondColor: UIColor.fromHex(string: "#06D6A0"), thirdColor: UIColor.fromHex(string: "#E84855"))
        footerView_indicator.center = CGPoint(x: Global.Constants.screenWidth / 2, y: 25)
        footerView_indicator.state = .running
        footerView.addSubview(footerView_indicator)
        view.addSubview(footerView)
        
        tableView.tableFooterView = footerView
    }
    
    func setupGesture() {
        // 添加右滑手势
        leftEdgeView = UIView(frame: CGRect(x: 0, y: 0, width: Global.Config.edgePanGestureThreshold, height: Global.Constants.screenHeight))
        view.addSubview(leftEdgeView)
        let swipeRight = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeRight(sender:)))
        leftEdgeView.addGestureRecognizer(swipeRight)
        
        // 添加左滑手势
        rightEdgeView = UIView(frame: CGRect(x: Global.Constants.screenWidth - Global.Config.edgePanGestureThreshold, y: 0, width: Global.Config.edgePanGestureThreshold, height: Global.Constants.screenHeight))
        view.addSubview(rightEdgeView)
        let swipeLeft = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeLeft(sender:)))
        rightEdgeView.addGestureRecognizer(swipeLeft)
        
        let menuTapped = UITapGestureRecognizer(target: self, action: #selector(menuTapped(_:)))
        menuBtn.addGestureRecognizer(menuTapped)
        let moreTapped = UITapGestureRecognizer(target: self, action: #selector(moreTapped(_:)))
        moreBtn.addGestureRecognizer(moreTapped)
    }
    
    func handleSwipeRight(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            leftEdgeView.frame.size.width = Global.Constants.screenWidth
        case .ended, .cancelled, .failed:
            leftEdgeView.frame.size.width = Global.Config.edgePanGestureThreshold
        default:
            break
        }
        handleMenu(menuView, recognizer: sender)
    }
    
    func handleSwipeLeft(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            rightEdgeView.frame.size.width = Global.Constants.screenWidth
        case .ended, .cancelled, .failed:
            rightEdgeView.frame.size.width = Global.Config.edgePanGestureThreshold
        default:
            break
        }
        handleNodeList(nodeListView, recognizer: sender)
    }
    
    @IBAction func menuTapped(_ sender: FabButton) {
        showMenu(menuView)
    }
    
    @IBAction func moreTapped(_ sender: FabButton) {
        showNodeList(nodeListView)
    }
    
}

// MARK: UITableViewDelegate & UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topicOverviewArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Global.Cells.topicOverview, for: indexPath) as! TopicOverviewTableViewCell
        cell.setData(data: topicOverviewArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.tableView.isRefreshing {
            return
        }
        selectedIndexPath = indexPath
        
        let presentBlock = {
            let cell = tableView.cellForRow(at: indexPath) as! TopicOverviewTableViewCell
            cell.data?.markRead = true
            cell.configureReadState(state: .read)
            
            let topicDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Global.ViewControllers.topicDetail) as! TopicDetailViewController
            topicDetailViewController.overviewData = self.topicOverviewArray[indexPath.row]
            
            NetworkManager.shared.getTopicDetail(url: self.topicOverviewArray[indexPath.row].href, success: { (topicModel) in
                delay(seconds: 0.4, completion: { 
                    topicDetailViewController.topicModel = topicModel
                })
            }, failure: { (error) in
                print(error)
                // TODO: failure toast
            })
            
            self.present(topicDetailViewController, animated: true, completion: nil)
        }
        switch navController.state {
        case .collapsed:
            navController.showNavbar(animated: true, duration: 0.3)
            delay(seconds: 0.3, completion: presentBlock)
        default:
            presentBlock()
        }
    }

}

// MARK: ScrollingNavigationControllerDelegate
extension HomeViewController: ScrollingNavigationControllerDelegate {
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        navController!.showNavbar(animated: true)
        return true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let oldY = tableView.frame.origin.y
        let newY = navController!.navigationBar.frame.height + navController!.navigationBar.frame.origin.y
        tableView.frame.origin.y = newY
        tableView.frame.size.height += oldY - newY
        tableView.scrollViewDidScroll(scrollView)
        
        // 根据 offset 改变 navigationBar 阴影
        let newRadius = min(1, max(tableView.contentOffset.y / 80, 0)) * navigationBarMaxShadowRadius
        navController.navigationBar.layer.shadowRadius = newRadius
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        tableView.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
}

// MARK: ExpandingTransitionPresentingViewController
extension HomeViewController: ExpandingTransitionPresentingViewController {
    func expandingTransitionTargetView(forTransition transition: ExpandingCellTransition) -> UIView! {
        if let indexPath = selectedIndexPath {
            return tableView.cellForRow(at: indexPath)
        } else {
            return nil
        }
    }
}

// MARK: PullToRefreshDelegate
extension HomeViewController: PullToRefreshDelegate {
    func pullToRefreshDidRefresh(_ refreshView: PullToRefresh) {
        let successBlock: (Array<TopicOverviewModel>) -> Void = { res in
            var newItems = Array<TopicOverviewModel>()
            for item in res {
                if self.topicOverviewArray.isEmpty || item.id != self.topicOverviewArray[0].id {
                    newItems.append(item)
                } else {
                    break
                }
            }
            self.topicOverviewArray.insert(contentsOf: newItems, at: 0)
            
            delay(seconds: 0.6, completion: {
                self.tableView.isRefreshing = false
                self.tableView.reloadData()
            })
        }
        
        let failureBlock: (String) -> Void = { error in
            self.tableView.isRefreshing = false
            // TODO: failure toast
        }
        
        self.category.loadTopics(success: successBlock, failure: failureBlock)
    }
}

// MARK: SelectNodeDelegate
extension HomeViewController: SelectNodeDelegate {
    func didSelectNode(node: NodeModel) {
        if self.category.name == node.name {
            return
        }
        topicOverviewArray.removeAll()
        tableView.reloadData()
        indicator.state = .running
        
        let successBlock: (Array<TopicOverviewModel>) -> Void = { res in
            self.topicOverviewArray = res
            self.indicator.state = .stopping
            self.tableView.isHidden = false
            self.navController.showNavbar(animated: false)
            self.tableView.reloadData()
        }
        let failureBlock: (String) -> Void = { error in
            self.indicator.state = .stopping
            self.tableView.isHidden = false
            // TODO: failure toast
        }
        node.loadTopics(success: successBlock, failure: failureBlock)
        
        self.title = node.name
        self.category = node
    }
}

