//
//  File.swift
//  NightMode
//
//  Created by baiwei－mac on 17/1/6.
//  Copyright © 2017年 YuHua. All rights reserved.
//

import Foundation
import UIKit

let NightChange = "NightChange"

class NightManager {
    
    //使用sharedInstance来调用获取颜色的方法
    static let sharedInstance = NightManager()
    var isNight = false
    let light = ["white":UIColor.white,
                 "black":UIColor.black,
                 "orange":UIColor.orange,
                 "gray":UIColor.gray.withAlphaComponent(0.5),
                 "blue":UIColor.blue]
    //夜间颜色数组
    let dark = ["white":UIColor.black,
                "black":UIColor.white,
                "orange":UIColor.white,
                "gray":UIColor.black.withAlphaComponent(0.5),
                "blue":UIColor.white]
    
    let lingtImage = ["image1":UIImage(named: "Light")!]
    
    let darkImage = ["image1":UIImage(named: "Night")!]
    
    
    func color(color: String) -> UIColor {
        
        return (isNight ? dark[color] : light[color])!
    }
    
    func image(name: String) -> UIImage {
        
        return (isNight ? darkImage[name] : lingtImage[name])!
    }
}


class CustomSupVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(setViewColor), name: NSNotification.Name(rawValue: NightChange), object: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return NightManager.sharedInstance.isNight ? .lightContent : .default
    }
    
    func setViewColor() {
        print("注意：子类没有实现该方法！会导致夜间模式颜色不正确！")
    }
}
