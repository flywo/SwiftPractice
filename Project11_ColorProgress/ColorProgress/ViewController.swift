//
//  ViewController.swift
//  ColorProgress
//
//  Created by baiwei－mac on 16/12/8.
//  Copyright © 2016年 YuHua. All rights reserved.
//

import UIKit

let YHRect = UIScreen.main.bounds
let YHHeight = YHRect.size.height
let YHWidth = YHRect.size.width
let ProgressRect = CGRect(x: 20, y: 200, width: YHWidth-40, height: 20)

class ViewController: UIViewController {
    
    
    let colorProgress = ColorProgress(frame: ProgressRect)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (time) in
            self.colorProgress.progress += 0.08
            if self.colorProgress.progress >= 1.0 {
                time.invalidate()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupView() {
        view.backgroundColor = .black
        view.addSubview(colorProgress)
    }

}

