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

class ViewController: UIViewController {
    @IBOutlet weak var postBtn: FabButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuBtn: FabButton!
    @IBOutlet weak var moreBtn: FabButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(tableView, delay: 40.0)
            navigationController.navigationBar.topItem!.title = "111"
            let leftButton = IconButton(image: Icon.cm.menu)
            navigationItem.title = "test"
            navigationController.navigationBar.topItem!.leftViews = [leftButton]
        }
        prepareMaterial()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(tableView, delay: 40.0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func prepareMaterial() {
        postBtn.image = Icon.add
        menuBtn.image = Icon.cm.menu
        moreBtn.image = Icon.cm.moreHorizontal
//        menuBtn.backgroundColor = UIColor.clear
        
    }
    
    @IBAction func menuTapped(_ sender: FabButton) {
    }
    
    @IBAction func moreTapped(_ sender: FabButton) {
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postOverviewCell")!
        return cell
    }
}

extension ViewController: ScrollingNavigationControllerDelegate {
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

