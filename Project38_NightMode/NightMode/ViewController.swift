//
//  ViewController.swift
//  NightMode
//
//  Created by baiwei－mac on 17/1/6.
//  Copyright © 2017年 YuHua. All rights reserved.
//

import UIKit


/*夜间模式，实现思路：
 1.配置夜间和白天的数据，分别保存
 2.配置数据时，通过单例manager的一个方法去取数据，该方法内判断是否是夜间模式，返回不同的数据
 3.用户点击切换后，需要：
    1.把manager的是否是夜间模式标志位切换
    2.截取当前屏幕，覆盖到最上层，然后图片用动画fadeOut消失----这一步不是必须，只是让变化更加平滑
    3.将主题变化了通知到其它view，其它view刷新
 4.应该把manager的判断是否是夜间模式的字段保存到配置文件中，下次打开app记录上次退出时的状态
 */
let YHRect = UIScreen.main.bounds
let YHHeight = YHRect.size.height
let YHWidth = YHRect.size.width
let YHNoNavRect = CGRect(x: 0, y: 0, width: YHWidth, height: YHHeight - 64)
let YHNoTarRect = CGRect(x: 0, y: 0, width: YHWidth, height: YHHeight - 49)
let YHNoNavTarRect = CGRect(x: 0, y: 0, width: YHWidth, height: YHHeight - 49 - 64)


class ViewController: CustomSupVC {
    
    
    let label = UILabel(frame: CGRect(x: 10, y: 20, width:YHWidth-20, height:300))
    let imageView = UIImageView(frame: CGRect(x: 30, y: 320, width: YHWidth-60, height: 200))
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setViewColor()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setupView() {
        
        label.textAlignment = .left
        label.numberOfLines = 0//如果指定为0，则label可以自动换行，多行显示，知道不能显示完为止。
        label.text = "夜间模式，实现思路：\n1.配置夜间也白天的，分别保存\n2.配置数据时，通过单例manager的一个方法去取数据，该方法内判断是否是夜间模式，返回不同的数据\n3.用户点击切换后，需要：\n    1.把manager的是否是夜间模式标志位切换\n    2.截取当前屏幕，覆盖到最上层，然后图片用动画fadeOut消失\n    3.将主题变化了通知到其它view，其它view刷新\n4.应该把manager的判断是否是夜间模式的字段保存到配置文件中，下次打开app记录上次退出时的状态"
        
        let witch = UISwitch()
        witch.center = CGPoint(x: view.center.x, y:YHHeight-80)
        witch.addTarget(self, action: #selector(changeNight(sender:)), for: .valueChanged)
        
        view.addSubview(witch)
        view.addSubview(label)
        view.addSubview(imageView)
    }
    
    
    func changeNight(sender: UISwitch) {
        fadeAnimation()
        NightManager.sharedInstance.isNight = sender.isOn
        NotificationCenter.default.post(name: NSNotification.Name(NightChange), object: nil)
    }
    
    
    //渐变动画
    func fadeAnimation() {
        //模拟器是无法看到快照的，真机可以看到，模拟器运行屏幕会闪一下就是这个原因
        let snaphot = UIApplication.shared.keyWindow?.snapshotView(afterScreenUpdates: false)
        UIApplication.shared.keyWindow?.addSubview(snaphot!)
        UIView.animate(withDuration: 0.3, animations: { 
            snaphot?.alpha = 0
            }) { (_) in
                snaphot?.removeFromSuperview()
        }
    }

    
    override func setViewColor() {
        //改变状态栏
        setNeedsStatusBarAppearanceUpdate()
        imageView.image = NightManager.sharedInstance.image(name: "image1")
        view.backgroundColor = NightManager.sharedInstance.color(color: "white")
        label.textColor = NightManager.sharedInstance.color(color: "orange")
        tabBarController?.tabBar.backgroundColor = NightManager.sharedInstance.color(color: "gray")
        tabBarController?.tabBar.tintColor = NightManager.sharedInstance.color(color: "blue")
    }
}

