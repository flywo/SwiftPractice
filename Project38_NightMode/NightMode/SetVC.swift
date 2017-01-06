//
//  SetVC.swift
//  NightMode
//
//  Created by baiwei－mac on 17/1/6.
//  Copyright © 2017年 YuHua. All rights reserved.
//

import UIKit

class SetVC: CustomSupVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        setViewColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setViewColor() {
        view.backgroundColor = NightManager.sharedInstance.color(color: "white")
        tabBarController?.tabBar.tintColor = NightManager.sharedInstance.color(color: "blue")
    }
}
