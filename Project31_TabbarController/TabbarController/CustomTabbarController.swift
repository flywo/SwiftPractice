//
//  CustomTabbarController.swift
//  TabbarController
//
//  Created by baiwei－mac on 16/12/29.
//  Copyright © 2016年 YuHua. All rights reserved.
//

import UIKit


let YHRect = UIScreen.main.bounds
let YHHeight = YHRect.size.height
let YHWidth = YHRect.size.width
let YHNoNavRect = CGRect(x: 0, y: 0, width: YHWidth, height: YHHeight - 64)
let YHNoTarRect = CGRect(x: 0, y: 0, width: YHWidth, height: YHHeight - 49)
let YHNoNavTarRect = CGRect(x: 0, y: 0, width: YHWidth, height: YHHeight - 49 - 64)


class CustomTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //强制跳转到B页面
        selectedIndex = 1
        selectedViewController = viewControllers?[selectedIndex]
    }
    
    
    func setupView() {
        
        view.backgroundColor = .white
        
        let avc = AVC()
        avc.title = "AVC"
        avc.tabBarItem.title = "A"
        avc.tabBarItem.image = UIImage(named: "Game")
        
        let bvc = BVC()
        let bnv = UINavigationController(rootViewController: bvc)
        bvc.title = "BVC"
        bvc.tabBarItem.title = "B"
        bvc.tabBarItem.image = UIImage(named: "Home")
        
        let cvc = CVC()
        cvc.title = "CVC"
        cvc.tabBarItem.title = "C"
        cvc.tabBarItem.image = UIImage(named: "Setting")
        
        viewControllers = [avc, bnv, cvc]
    }
}
