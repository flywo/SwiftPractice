//
//  Extension.swift
//  TumblrMenu
//
//  Created by baiwei－mac on 16/12/16.
//  Copyright © 2016年 YuHua. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    //设置按钮图片在上，文字在下的效果
    func alignContentVerticallyByCenter() {
        contentHorizontalAlignment = .center
        contentVerticalAlignment = .center
        
        //图片与title之间有一个默认的间隔10
        let offset: CGFloat = 10
        
        //在有的iOS版本上，会出现获得不到frame的情况，加上下面这两句可以100%得到
        titleLabel?.backgroundColor = backgroundColor
        imageView?.backgroundColor = backgroundColor
        
        //title
        let titleWidth = titleLabel?.frame.size.width
        let titleHeight = titleLabel?.frame.size.height
        let titleLef = titleLabel?.frame.origin.x
        let titleRig = frame.size.width-titleLef!-titleWidth!
        
        //image
        let imageWidth = imageView?.frame.size.width
        let imageHeight = imageView?.frame.size.height
        let imageLef = imageView?.frame.origin.x
        let imageRig = frame.size.width-imageLef!-imageWidth!
        
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -imageLef!, bottom: titleHeight!, right: -imageRig)
        titleEdgeInsets = UIEdgeInsets(top: imageHeight!+offset, left: -titleLef!, bottom: 0, right: -titleRig)
    }
}
