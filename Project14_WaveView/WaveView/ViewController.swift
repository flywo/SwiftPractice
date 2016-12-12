//
//  ViewController.swift
//  WaveView
//
//  Created by baiwei－mac on 16/12/12.
//  Copyright © 2016年 YuHua. All rights reserved.
//

import UIKit

let YHRect = UIScreen.main.bounds
let YHHeight = YHRect.size.height
let YHWidth = YHRect.size.width

class ViewController: UIViewController {
    
    let wave = WaveView(frame: CGRect(x: 0.0, y: 200.0, width: YHWidth, height: 31))

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupView() {
        wave.waveSpeed = 10
        wave.angularSpeed = 1.5
        view.addSubview(wave)
        
        let whiteView = UIView(frame: CGRect(x: 0.0, y: 230, width: YHWidth, height: YHHeight-230))
        whiteView.backgroundColor = .white
        view.addSubview(whiteView)
        
        let btn = UIButton(frame: CGRect(x: 100, y: 400, width: YHWidth-200, height: 30))
        btn.setTitle("开始", for: .normal)
        btn.setTitle("结束", for: .selected)
        btn.setTitleColor(.orange, for: .normal)
        view.addSubview(btn)
        btn.addTarget(self, action: #selector(changeStatus(_:)), for: .touchUpInside)
    }

    func changeStatus(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.isSelected ? wave.startWave() : wave.stopWaver()
    }
    
}

