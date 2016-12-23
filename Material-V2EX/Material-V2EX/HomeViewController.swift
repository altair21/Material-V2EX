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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuBtn: FabButton!
    @IBOutlet weak var moreBtn: FabButton!
    var menuView: MenuView = MenuView.sharedInstance
    var leftEdgeView: UIView!
    
    // Data
    var topicOverviewArray = Array<TopicOverviewModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(tableView, delay: 50.0)
        }
        
        let fpsLabel = V2FPSLabel(frame: CGRect(x: 0, y: Global.screenHeight - 40, width: 80, height: 40))
        view.addSubview(fpsLabel)
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        prepareMaterial()
        setupGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NetworkManager.sharedInstance.getHotTopics(success: { res in
            for (_, item) in res {
                self.topicOverviewArray.append(TopicOverviewModel(data: item))
            }
            self.tableView.reloadData()
        }, failure: { error in
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func prepareMaterial() {
        postBtn.image = Icon.add
        menuBtn.image = Icon.cm.menu
        moreBtn.image = Icon.cm.moreHorizontal
        
    }
    
    func setupGesture() {
        leftEdgeView = UIView(frame: CGRect(x: 0, y: 0, width: Global.edgePanGestureThreshold, height: Global.screenHeight))
        view.addSubview(leftEdgeView)
        let swipeRight = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeRight(sender:)))
        leftEdgeView.addGestureRecognizer(swipeRight)
    }
    
    func handleSwipeRight(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            leftEdgeView.frame.size.width = Global.screenWidth
            if let navigationController = navigationController as? ScrollingNavigationController {
                navigationController.stopFollowingScrollView()
            }
        case .ended, .cancelled, .failed:
            leftEdgeView.frame.size.width = Global.edgePanGestureThreshold
            if let navigationController = navigationController as? ScrollingNavigationController {
                navigationController.followScrollView(tableView, delay: 50.0)
            }
        default:
            break
        }
        handleMenu(menuView, recognizer: sender)
    }
    
    @IBAction func menuTapped(_ sender: FabButton) {
        showMenu(menuView)
    }
    
    @IBAction func moreTapped(_ sender: FabButton) {
    }
    
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topicOverviewArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Global.topicOverviewCell)! as! TopicOverviewTableViewCell
        cell.setData(data: topicOverviewArray[indexPath.row])
        return cell
    }
}

extension HomeViewController: ScrollingNavigationControllerDelegate {
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.showNavbar(animated: true)
        }
        return true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let navigationController = navigationController {
            let oldY = tableView.frame.origin.y
            let newY = navigationController.navigationBar.frame.height + navigationController.navigationBar.frame.origin.y
            tableView.frame.origin.y = newY
            tableView.frame.size.height += oldY - newY
        }
    }
}



