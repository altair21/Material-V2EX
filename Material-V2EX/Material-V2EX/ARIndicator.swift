//
//  ARIndicator.swift
//  Material-V2EX
//
//  Created by altair21 on 16/12/27.
//  Copyright © 2016年 altair21. All rights reserved.
//

import UIKit

class ARIndicator: UIView {
    enum ARIndicatorState {
        case running
        case stopping
    }
    
    var firstColor = UIColor(red: 0.984313725, green: 0.737254902, blue: 0.019607843, alpha: 1.0)
    var secondColor = UIColor(red: 0.258823529, green: 0.521568627, blue: 0.956862745, alpha: 1.0)
    var thirdColor = UIColor(red: 0.917647059, green: 0.262745098, blue: 0.207843137, alpha: 1.0)
    var state = ARIndicatorState.stopping {
        didSet {
            switch state {
            case .stopping:
                self.isHidden = true
                stopAnimation()
            case .running:
                self.isHidden = false
                startAnimation()
            }
        }
    }
    var size: CGSize = CGSize(width: 40, height: 40) {
        didSet {
            stopAnimation()
            self.frame.size = size
            setupCircle()
        }
    }
    
    private let smallCircle: CAShapeLayer = CAShapeLayer()
    private let mediumCircle = CAShapeLayer()
    private let largeCircle = CAShapeLayer()
    
    init(firstColor: UIColor = UIColor(red: 0.984313725, green: 0.737254902, blue: 0.019607843, alpha: 1.0), secondColor: UIColor = UIColor(red: 0.258823529, green: 0.521568627, blue: 0.956862745, alpha: 1.0), thirdColor: UIColor = UIColor(red: 0.917647059, green: 0.262745098, blue: 0.207843137, alpha: 1.0)) {
        super.init(frame: CGRect(x: 100, y: 100, width: 40, height: 40))
        
        self.firstColor = firstColor
        self.secondColor = secondColor
        self.thirdColor = thirdColor
        
        self.backgroundColor = UIColor.clear
        setupCircle()
        
    }
    
    init() {
        super.init(frame: CGRect(x: 100, y: 100, width: 40, height: 40))
        
        self.backgroundColor = UIColor.clear
        setupCircle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCircle() {
        state = .stopping
        
        if let sublayers = self.layer.sublayers {
            for sublayer in sublayers {
                sublayer.removeFromSuperlayer()
            }
        }
        
        let smallRadius = self.frame.size.width / 2 * 0.3
        let mediumRadius = self.frame.size.width / 2 * 0.5
        let largeRadius = self.frame.size.width / 2 * 0.7
        
        smallCircle.strokeColor = self.firstColor.cgColor
        smallCircle.fillColor = UIColor.clear.cgColor
        smallCircle.lineWidth = 2.0
        smallCircle.strokeStart = 0.0
        smallCircle.strokeEnd = 0.7
        smallCircle.path = UIBezierPath(ovalIn: CGRect(x: self.frame.size.width / 2 - smallRadius,
                                                       y: self.frame.size.height / 2 - smallRadius,
                                                       width: 2 * smallRadius,
                                                       height: 2 * smallRadius)).cgPath
        smallCircle.bounds = smallCircle.path!.boundingBox
        smallCircle.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        self.layer.addSublayer(smallCircle)
        
        mediumCircle.strokeColor = self.secondColor.cgColor
        mediumCircle.fillColor = UIColor.clear.cgColor
        mediumCircle.lineWidth = 2.0
        mediumCircle.strokeStart = 0.0
        mediumCircle.strokeEnd = 0.8
        mediumCircle.path = UIBezierPath(ovalIn: CGRect(x: self.frame.size.width / 2 - mediumRadius,
                                                        y: self.frame.size.height / 2 - mediumRadius,
                                                        width: 2 * mediumRadius,
                                                        height: 2 * mediumRadius)).cgPath
        mediumCircle.bounds = mediumCircle.path!.boundingBox
        mediumCircle.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        self.layer.addSublayer(mediumCircle)
        
        largeCircle.strokeColor = self.thirdColor.cgColor
        largeCircle.fillColor = UIColor.clear.cgColor
        largeCircle.lineWidth = 2.0
        largeCircle.strokeStart = 0.0
        largeCircle.strokeEnd = 0.9
        largeCircle.path = UIBezierPath(ovalIn: CGRect(x: self.frame.size.width / 2 - largeRadius,
                                                       y: self.frame.size.height / 2 - largeRadius,
                                                       width: 2 * largeRadius,
                                                       height: 2 * largeRadius)).cgPath
        largeCircle.bounds = largeCircle.path!.boundingBox
        largeCircle.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        self.layer.addSublayer(largeCircle)

    }
    
    private func startAnimation() {
        let smallRotate = CABasicAnimation(keyPath: "transform.rotation")
        smallRotate.duration = 0.9
        smallRotate.repeatCount = .infinity
        smallRotate.fromValue = 0.0
        smallRotate.toValue = Float.pi * 2
        smallCircle.add(smallRotate, forKey: nil)
        
        let mediumRotate = CABasicAnimation(keyPath: "transform.rotation")
        mediumRotate.duration = 1.3
        mediumRotate.repeatCount = .infinity
        mediumRotate.fromValue = 0.0
        mediumRotate.toValue = Float.pi * 2
        mediumCircle.add(mediumRotate, forKey: nil)
        
        let largeRotate = CABasicAnimation(keyPath: "transform.rotation")
        largeRotate.duration = 2.3
        largeRotate.repeatCount = .infinity
        largeRotate.fromValue = 0.0
        largeRotate.toValue = Float.pi * 2
        largeCircle.add(largeRotate, forKey: nil)
    }
    
    private func stopAnimation() {
        smallCircle.removeAllAnimations()
        mediumCircle.removeAllAnimations()
        largeCircle.removeAllAnimations()
    }

}
