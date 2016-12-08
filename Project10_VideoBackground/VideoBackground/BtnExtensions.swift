//
//  BtnExtensions.swift
//  VideoBackground
//
//  Created by baiwei－mac on 16/12/8.
//  Copyright © 2016年 YuHua. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func customBtn(customTitle title: String) {
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 5.0
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1.0
    }
}
