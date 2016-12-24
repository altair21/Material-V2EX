//
//  UIImageView+Cache.swift
//  Material-V2EX
//
//  Created by altair21 on 16/12/24.
//  Copyright © 2016年 altair21. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {

    func setImageWith(string: String) {
        let url = URL(string: string)
        self.kf.setImage(with: url)
    }

}
