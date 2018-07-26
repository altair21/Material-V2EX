//
//  UIColor+Extension.swift
//  Material-V2EX
//
//  Created by altair21 on 16/12/28.
//  Copyright © 2016年 altair21. All rights reserved.
//

import UIKit

extension UIColor {
    static func fromHex(string hexColor: String) -> UIColor {
        // 存储转换后的数值
        var red:UInt32 = 0, green:UInt32 = 0, blue:UInt32 = 0
        // 计算前缀数量
        var prefixCount = 0
        
        if hexColor.hasPrefix("0x") || hexColor.hasPrefix("0X") {
            prefixCount = 2 // 前缀有两位
        }
        if hexColor.hasPrefix("#") {
            prefixCount = 1 // 前缀有一位
        }
        // 分别转换进行转换
        Scanner(string: hexColor[(0+prefixCount)..<(2+prefixCount)]).scanHexInt32(&red)
        
        Scanner(string: hexColor[(2+prefixCount)..<(4+prefixCount)]).scanHexInt32(&green)
        
        Scanner(string: hexColor[(4+prefixCount)..<(6+prefixCount)]).scanHexInt32(&blue)
        
        
        return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
    }
}

// string[int..<int]截取字符串
extension String {
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
            
            return String(self[startIndex..<endIndex])
        }
    }
}
