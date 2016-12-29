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
        smallLinePath.move(to: CGPoint(x: self.frame.size.width / 2 + smallRadius, y: -10))
        smallLinePath.addLine(to: CGPoint(x: self.frame.size.width / 2 + smallRadius, y: -25))
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
        mediumLinePath.move(to: CGPoint(x: self.frame.size.width / 2 + mediumRadius, y: -10))
        mediumLinePath.addLine(to: CGPoint(x: self.frame.size.width / 2 + mediumRadius, y: -33))
        mediumLinePath.addQuadCurve(to: CGPoint(x: circleCenter.x, y: circleCenter.y - mediumRadius),
                                    controlPoint: CGPoint(x: circleCenter.x + mediumRadius, y: circleCenter.y - mediumRadius))
        mediumLinePath.addArc(withCenter: circleCenter, radius: mediumRadius, startAngle: .pi * 1.5, endAngle: -.pi * 0.5, clockwise: false)
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
        largeLinePath.move(to: CGPoint(x: self.frame.size.width / 2 + largeRadius, y: -10))
        largeLinePath.addLine(to: CGPoint(x: self.frame.size.width / 2 + largeRadius, y: -41))
        largeLinePath.addQuadCurve(to: CGPoint(x: circleCenter.x, y: circleCenter.y - largeRadius),
                                   controlPoint: CGPoint(x: circleCenter.x + largeRadius, y: circleCenter.y - largeRadius))
        largeLinePath.addArc(withCenter: circleCenter, radius: largeRadius, startAngle: .pi * 1.5, endAngle: -.pi * 0.5, clockwise: false)
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
        progress = min(max(offsetY / (refreshThresholdHeight + 5), 0.0), 1.0)
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
        
        addCAAnimationTo(layer: smallCircle, strokeDuration: 0.5, strokeStart: 0.45, rotationDuration: 0.9)
        addCAAnimationTo(layer: mediumCircle, strokeDuration: 0.7, strokeStart: 0.45, rotationDuration: 1.05)
        addCAAnimationTo(layer: largeCircle, strokeDuration: 0.9, strokeStart: 0.5, rotationDuration: 1.2)
    }
    
    private func addCAAnimationTo(layer: CAShapeLayer, strokeDuration: CFTimeInterval, strokeStart: CGFloat, rotationDuration: CFTimeInterval) {
        let preDuration = strokeDuration
        
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = 0.0
        strokeStartAnimation.toValue = strokeStart
        strokeStartAnimation.duration = preDuration
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0.3
        strokeEndAnimation.toValue = 1.0
        strokeEndAnimation.duration = preDuration
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.duration = rotationDuration
        rotationAnimation.repeatCount = .infinity
        rotationAnimation.fromValue = Float.pi * 2
        rotationAnimation.toValue = 0.0
        rotationAnimation.beginTime = CACurrentMediaTime() + preDuration
        layer.strokeStart = strokeStart
        layer.strokeEnd = 1.0
        layer.add(strokeStartAnimation, forKey: nil)
        layer.add(strokeEndAnimation, forKey: nil)
        layer.add(rotationAnimation, forKey: nil)
    }
    
    private func endRefreshing() {
        smallCircle.removeAllAnimations()
        mediumCircle.removeAllAnimations()
        largeCircle.removeAllAnimations()
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            var newInsets = self.contentInset
            newInsets.top -= self.refreshThresholdHeight
            self.contentInset = newInsets
        }) { (_) in
            self.smallCircle.strokeStart = 0.0
            self.mediumCircle.strokeStart = 0.0
            self.largeCircle.strokeStart = 0.0
        }
    }
    
    private func redrawFrom(progress: CGFloat) {
        smallCircle.strokeEnd = progress * 0.3
        smallCircle.opacity = Float(progress)
        mediumCircle.strokeEnd = progress * 0.23
        mediumCircle.opacity = Float(progress)
        largeCircle.strokeEnd = progress * 0.23
        largeCircle.opacity = Float(progress)
    }

}
