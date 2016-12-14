//
//  RootVC.swift
//  ChildVCTransition
//
//  Created by baiwei－mac on 16/12/14.
//  Copyright © 2016年 YuHua. All rights reserved.
//

import UIKit

let YHRect = UIScreen.main.bounds
let YHHeight = YHRect.size.height
let YHWidth = YHRect.size.width

let JumpNotification = "JUMP"

class RootVC: UIViewController {
    
    var currentChildNumber = 0
    
    //最简单的转场实现方式，该方式是在rootVC的子VC之间转场

    override func viewDidLoad() {
        super.viewDidLoad()
        setupChild()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupChild() {
        addChildViewController(ChildAVC())
        addChildViewController(ChildBVC())
        
        view.addSubview((childViewControllers.first?.view)!)
        
        //监听跳转通知，NotificationCenter通知中心
        NotificationCenter.default.addObserver(self, selector: #selector(jump), name: NSNotification.Name(rawValue: JumpNotification), object: nil)
    }
    
    func jump() {
        //options:跳转的方式
        transition(from: currentChildNumber==0 ? childViewControllers.first! : childViewControllers.last!,
                   to: currentChildNumber==0 ? childViewControllers.last! : childViewControllers.first!,
                   duration: 1,
                   options: currentChildNumber==0 ? .transitionFlipFromLeft : .transitionFlipFromRight,
                   animations: nil,
                   completion: nil)
        currentChildNumber = currentChildNumber == 0 ? 1 : 0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: JumpNotification), object: nil)
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
