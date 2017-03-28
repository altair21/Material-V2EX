//
//  BaseWKWebViewTableViewCell.swift
//  Material-V2EX
//
//  Created by altair21 on 17/3/28.
//  Copyright © 2017年 altair21. All rights reserved.
//

import UIKit
import WebKit

class BaseWKWebViewTableViewCell: UITableViewCell {
    lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        webView.scrollView.isScrollEnabled = false
        webView.backgroundColor = UIColor.white
        webView.isOpaque = true
        return webView
    }()

    var indexPath: IndexPath?
}

extension BaseWKWebViewTableViewCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
}

extension BaseWKWebViewTableViewCell: WKNavigationDelegate {
    func checkMember(url: String) -> Bool {
        let memberAbbrPattern = "^/member/[a-zA-Z0-9_-]{3,16}$"
        let memberAbbrReg = try! NSRegularExpression(pattern: memberAbbrPattern, options: .caseInsensitive)
        let results = memberAbbrReg.matches(in: url, options: [], range: NSRange(location: 0, length: url.characters.count))
        print(results)
        return results.count > 0
    }
    
    func getMemberName(url: String) -> String? {
        if checkMember(url: url) {
            if let range = url.range(of: "/member/") {
                return url.substring(from: range.upperBound)
            }
        }
        return nil
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
            if let newURL = navigationAction.request.url {
                if let username = getMemberName(url: newURL.absoluteString) {
                    let data = MemberModel(username: username, avatarURL: "", href: V2EX.indexURL + newURL.absoluteString)
                    let topicViewController = viewController(ofView: self) as! TopicDetailViewController
                    topicViewController.openMember(data: data, indexPath: indexPath ?? IndexPath(row: 0, section: 0))
                }
                decisionHandler(.cancel)
                return
            }
        }
        print(navigationAction.navigationType)
        print("ezio")
        decisionHandler(.allow)
    }
}
