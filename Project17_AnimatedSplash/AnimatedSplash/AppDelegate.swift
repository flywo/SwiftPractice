//
//  AppDelegate.swift
//  AnimatedSplash
//
//  Created by baiwei－mac on 16/12/14.
//  Copyright © 2016年 YuHua. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CAAnimationDelegate {

    var window: UIWindow?
    let mask = CALayer()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: YHRect)
        window?.rootViewController = ViewController()
        
        mask.contents = UIImage(named: "twitter")?.cgImage//这里需要是CGImage
        mask.contentsGravity = "resizeAspect"//图片显示风格
        mask.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)//边界
        mask.anchorPoint = CGPoint(x: 0.5, y: 0.5)//锚点
        mask.position = CGPoint(x: YHWidth/2, y: YHHeight/2)//位置
        window?.rootViewController?.view.layer.mask = mask
        window?.backgroundColor = UIColor(red: 31/255.0, green: 150/255.0, blue: 1, alpha: 1)
        
        animateMask()
        
        window?.makeKeyAndVisible()
        return true
    }
    
    func animateMask() {
        /*keyframe与basic区别：
         1.basic只能从一个数值到另一个数值
         2.keyframe使用一个nsarray保存这些值
         3.basic可以看做只有2个关键帧的keyframe关键帧动画
         */
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "bounds")
        keyFrameAnimation.delegate = self
        keyFrameAnimation.duration = 0.6
        keyFrameAnimation.beginTime = CACurrentMediaTime() + 0.5
        keyFrameAnimation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)]
        let firstBounds = NSValue(cgRect: mask.bounds)
        let secondBounds = NSValue(cgRect: CGRect(x: 0, y: 0, width: 300, height: 300))
        let finalBounds = NSValue(cgRect: CGRect(x: 0, y: 0, width: 1100, height: 1100))
        keyFrameAnimation.values = [firstBounds, secondBounds, finalBounds]
        keyFrameAnimation.keyTimes = [0, 0.8, 1]
        mask.add(keyFrameAnimation, forKey: "bounds")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        window?.rootViewController?.view.layer.mask = nil
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

