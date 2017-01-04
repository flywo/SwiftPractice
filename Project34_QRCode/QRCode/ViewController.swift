//
//  ViewController.swift
//  QRCode
//
//  Created by baiwei－mac on 17/1/3.
//  Copyright © 2017年 YuHua. All rights reserved.
//

import UIKit


let YHRect = UIScreen.main.bounds
let YHHeight = YHRect.size.height
let YHWidth = YHRect.size.width
let YHNoNavRect = CGRect(x: 0, y: 0, width: YHWidth, height: YHHeight - 64)
let YHNoTarRect = CGRect(x: 0, y: 0, width: YHWidth, height: YHHeight - 49)
let YHNoNavTarRect = CGRect(x: 0, y: 0, width: YHWidth, height: YHHeight - 49 - 64)


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    func setupView() {
        
        title = "选择方式"
        view.backgroundColor = .white
        for (index, title) in ["扫描二维码","图片获取"].enumerated() {
            createButton(rect: CGRect(x: 100, y: 100+100*index, width: Int(YHWidth)-200, height: 40), title: title)
        }
    }
    
    
    func createButton(rect: CGRect, title: String) {
        
        let btn = UIButton(frame: rect)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.orange, for: .normal)
        btn.addTarget(self, action: #selector(btnSeletecd(sender:)), for: .touchUpInside)
        view.addSubview(btn)
    }

    
    func btnSeletecd(sender: UIButton) {
        
        switch sender.currentTitle! {
        case "扫描二维码":
            navigationController?.pushViewController(ScanVC(), animated: true)
        default:
            navigationController?.pushViewController(ImageVC(), animated: true)
        }
    }
}

