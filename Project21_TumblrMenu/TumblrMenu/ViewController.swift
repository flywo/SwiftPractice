//
//  ViewController.swift
//  TumblrMenu
//
//  Created by baiwei－mac on 16/12/16.
//  Copyright © 2016年 YuHua. All rights reserved.
//

import UIKit

let YHRect = UIScreen.main.bounds
let YHHeight = YHRect.size.height
let YHWidth = YHRect.size.width

class ViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    func setupView() {
        view.layer.contents = UIImage(named: "8")?.cgImage
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        present(MenuViewController(), animated: true, completion: nil)
    }
    

}

