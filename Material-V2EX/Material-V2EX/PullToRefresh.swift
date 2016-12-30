//
//  PullToRefresh.swift
//  Material-V2EX
//
//  Created by altair21 on 16/12/28.
//  Copyright © 2016年 altair21. All rights reserved.
//

import UIKit

protocol PullToRefreshDelegate: class {
    func pullToRefreshDidRefresh(_ refreshView: PullToRefresh)
}

class PullToRefresh: UITableView {
    weak var pullToRefreshDelegate: PullToRefreshDelegate?
    
    var headerFirstColor = UIColor(red: 0.984313725, green: 0.737254902, blue: 0.019607843, alpha: 1.0) {
        didSet {
            setupUI()
        }
    }
    var headerSecondColor = UIColor(red: 0.258823529, green: 0.521568627, blue: 0.956862745, alpha: 1.0) {
        didSet {
            setupUI()
        }
    }
    var headerThirdColor = UIColor(red: 0.917647059, green: 0.262745098, blue: 0.207843137, alpha: 1.0) {
        didSet {
            setupUI()
        }
    }
    
    private let smallCircle = CAShapeLayer()
    private let mediumCircle = CAShapeLayer()
    private let largeCircle = CAShapeLayer()
    
    private let refreshThresholdHeight: CGFloat = 60    // don't change this value, otherwise bezier curve will mess
    var isRefreshing = false {
        didSet {
            if isRefreshing == oldValue {
                return
            }
            if isRefreshing {
                beginRefreshing()
            } else {
                endRefreshing()
            }
        }
    }
    private var progress: CGFloat = 0.0
    private var startAnimationTime: Date!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    private func setupUI() {
        smallCircle.removeFromSuperlayer()
        mediumCircle.removeFromSuperlayer()
        largeCircle.removeFromSuperlayer()
        
        let smallRadius = refreshThresholdHeight * 0.1
        let mediumRadius = refreshThresholdHeight * 0.18
        let largeRadius = refreshThresholdHeight * 0.25
        let circleCenter = CGPoint(x: self.frame.size.width / 2, y: -refreshThresholdHeight / 2)
        
        var smallCirclePath: CGPath!
        var mediumCirclePath: CGPath!
        var largeCirclePath: CGPath!
        
        smallCircle.strokeColor = self.headerFirstColor.cgColor
        smallCircle.fillColor = UIColor.clear.cgColor
        smallCircle.lineWidth = 2.0
        let smallLinePath = UIBezierPath()
        smallLinePath.move(to: CGPoint(x: self.frame.size.width / 2 + smallRadius, y: -5))
        smallLinePath.addLine(to: CGPoint(x: self.frame.size.width / 2 + smallRadius, y: -30))
        smallLinePath.addArc(withCenter: circleCenter, radius: smallRadius, startAngle: .pi * 2, endAngle: 0.0, clockwise: false)
        smallCirclePath = UIBezierPath(ovalIn: CGRect(x: self.frame.size.width / 2 - smallRadius,
                                                      y: -refreshThresholdHeight / 2 - smallRadius,
                                                      width: 2 * smallRadius,
                                                      height: 2 * smallRadius)).cgPath
        smallCircle.path = smallLinePath.cgPath
        smallCircle.bounds = smallCirclePath!.boundingBox
        smallCircle.position = circleCenter
        self.layer.addSublayer(smallCircle)
        
        mediumCircle.strokeColor = self.headerSecondColor.cgColor
        mediumCircle.fillColor = UIColor.clear.cgColor
        mediumCircle.lineWidth = 2.0
        let mediumLinePath = UIBezierPath()
        mediumLinePath.move(to: CGPoint(x: self.frame.size.width / 2 + mediumRadius, y: -5))
        mediumLinePath.addLine(to: CGPoint(x: self.frame.size.width / 2 + mediumRadius, y: -30))
        mediumLinePath.addArc(withCenter: circleCenter, radius: mediumRadius, startAngle: .pi * 2, endAngle: 0.0, clockwise: false)
        mediumCirclePath = UIBezierPath(ovalIn: CGRect(x: self.frame.size.width / 2 - mediumRadius,
                                                      y: -refreshThresholdHeight / 2 - mediumRadius,
                                                      width: 2 * mediumRadius,
                                                      height: 2 * mediumRadius)).cgPath
        mediumCircle.path = mediumLinePath.cgPath
        mediumCircle.bounds = mediumCirclePath!.boundingBox
        mediumCircle.position = circleCenter
        self.layer.addSublayer(mediumCircle)
        
        largeCircle.strokeColor = self.headerThirdColor.cgColor
        largeCircle.fillColor = UIColor.clear.cgColor
        largeCircle.lineWidth = 2.0
        let largeLinePath = UIBezierPath()
        largeLinePath.move(to: CGPoint(x: self.frame.size.width / 2 + largeRadius, y: -5))
        largeLinePath.addLine(to: CGPoint(x: self.frame.size.width / 2 + largeRadius, y: -30))
        largeLinePath.addArc(withCenter: circleCenter, radius: largeRadius, startAngle: .pi * 2, endAngle: 0.0, clockwise: false)
        largeCirclePath = UIBezierPath(ovalIn: CGRect(x: self.frame.size.width / 2 - largeRadius,
                                                          y: -refreshThresholdHeight / 2 - largeRadius,
                                                          width: 2 * largeRadius,
                                                          height: 2 * largeRadius)).cgPath

        largeCircle.path = largeLinePath.cgPath
        largeCircle.bounds = largeCirclePath!.boundingBox
        largeCircle.position = circleCenter
        self.layer.addSublayer(largeCircle)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = max(-(scrollView.contentOffset.y + scrollView.contentInset.top), 0.0)
        progress = max(offsetY / (refreshThresholdHeight + 5), 0.0)
        if !isRefreshing {
            redrawFrom(progress: progress)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if !isRefreshing && self.progress >= 1.0 {
            isRefreshing = true
            pullToRefreshDelegate?.pullToRefreshDidRefresh(self)
        }
    }
    
    private func beginRefreshing() {
        var newInsets = self.contentInset
        newInsets.top += self.refreshThresholdHeight
        let contentOffset = self.contentOffset
        UIView.animate(withDuration: 0.5, animations: {
            self.contentInset = newInsets
            self.contentOffset = contentOffset
        })
        
        addCAAnimationTo(layer: smallCircle, rotationDuration: 0.9)
        addCAAnimationTo(layer: mediumCircle, rotationDuration: 1.3)
        addCAAnimationTo(layer: largeCircle, rotationDuration: 1.6)
    }
    
    private func addCAAnimationTo(layer: CAShapeLayer, rotationDuration: CFTimeInterval) {

        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.duration = rotationDuration
        rotationAnimation.repeatCount = .infinity
        rotationAnimation.fromValue = Float.pi * 2
        rotationAnimation.toValue = 0.0
        layer.add(rotationAnimation, forKey: nil)
    }
    
    private func endRefreshing() {
        smallCircle.removeAllAnimations()
        mediumCircle.removeAllAnimations()
        largeCircle.removeAllAnimations()
        smallCircle.removeFromSuperlayer()
        mediumCircle.removeFromSuperlayer()
        largeCircle.removeFromSuperlayer()
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            var newInsets = self.contentInset
            newInsets.top -= self.refreshThresholdHeight
            self.contentInset = newInsets
        }) { _ in
            self.layer.addSublayer(self.smallCircle)
            self.layer.addSublayer(self.mediumCircle)
            self.layer.addSublayer(self.largeCircle)
        }
    }
    
    private func redrawFrom(progress: CGFloat) {
        let smallProgress = min(progress / 0.8, 1.0)
        let mediumProgress = min(progress / 0.9, 1.0)
        let largeProgress = min(progress, 1.0)
        smallCircle.strokeStart = smallProgress * 0.5
        smallCircle.strokeEnd = smallProgress
        smallCircle.opacity = Float(smallProgress)
        mediumCircle.strokeStart = mediumProgress * 0.4
        mediumCircle.strokeEnd = mediumProgress
        mediumCircle.opacity = Float(mediumProgress)
        largeCircle.strokeStart = largeProgress * 0.4
        largeCircle.strokeEnd = largeProgress
        largeCircle.opacity = Float(largeProgress)
    }

}
