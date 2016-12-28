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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        transitioningDelegate = transition
        if navigationBarSnapshot != nil {
            navigationBarSnapshot.frame.origin.y = -navigationBarHeight
        }
        
        tableView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let indicator = ARIndicator(firstColor: UIColor.fromHex(string: "#1B9AAA"), secondColor: UIColor.fromHex(string: "#06D6A0"), thirdColor: UIColor.fromHex(string: "#E84855"))
        view.addSubview(indicator)
        indicator.size = CGSize(width: 60, height: 60)
        indicator.state = .running
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
