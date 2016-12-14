//
//  ChildAVC.swift
//  ChildVCTransition
//
//  Created by baiwei－mac on 16/12/14.
//  Copyright © 2016年 YuHua. All rights reserved.
//

import UIKit

class ChildAVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        
        //添加一个点击手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(jump))
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupView() {
        
    }
    
    func jump() {
        //发送跳转通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: JumpNotification), object: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
