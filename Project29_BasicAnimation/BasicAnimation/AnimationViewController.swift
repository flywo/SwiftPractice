//
//  AnimationViewController.swift
//  BasicAnimation
//
//  Created by baiwei－mac on 16/12/28.
//  Copyright © 2016年 YuHua. All rights reserved.
//

import UIKit

class AnimationViewController: UIViewController {
    
    
    var animationStyle: String!
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationBegin()
    }
    
    
    func setupView() {
        imageView.center = view.center
        imageView.backgroundColor = .orange
        view.backgroundColor = .white
        view.addSubview(imageView)
    }
    
    
    func animationBegin() {
        switch animationStyle {
        case "Position":
            positionAnimation()
        case "Opacity":
            opacityAnimation()
        case "Color":
            colorAnimation()
        case "Scale":
            scaleAnimation()
        default:
            rotationAnimation()
        }
    }
    
    
    func positionAnimation() {
        UIView.animate(withDuration: 0.3, animations: {
            self.imageView.center = CGPoint(x: 50, y: 50)
            }) { (_) in
                UIView.animate(withDuration: 0.3, animations: {
                    self.imageView.center = CGPoint(x: 50, y: YHHeight-50)
                    }, completion: { (_) in
                        UIView.animate(withDuration: 0.3, animations: {
                            self.imageView.center = CGPoint(x: YHWidth-50, y: YHHeight-50)
                            }, completion: { (_) in
                                UIView.animate(withDuration: 0.3, animations: {
                                    self.imageView.center = CGPoint(x: YHWidth-50, y: 50)
                                    }, completion: { (_) in
                                        UIView.animate(withDuration: 0.3, animations: {
                                            self.imageView.center = self.view.center
                                            }, completion: nil)
                                })
                        })
                })
        }
    }
    
    
    func opacityAnimation() {
        UIView.animate(withDuration: 0.5) { 
            self.imageView.alpha = 0
        }
    }
    
    
    func colorAnimation() {
        UIView.animate(withDuration: 0.5) { 
            self.imageView.backgroundColor = .red
        }
    }
    
    
    func scaleAnimation() {
        UIView.animate(withDuration: 0.5) {
            //这是在最初的基础上进行变化
            self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
        }
    }
    
    
    func rotationAnimation() {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
            //这是基于现在的基础进行变化
            self.imageView.transform = self.imageView.transform.rotated(by: CGFloat(M_PI))
            }) { [weak self](_) in//由于这里会造成循环引用，导致VC得不到释放的问题，所以，需要在block使self成为弱引用
                if let strongSelf = self {
                    strongSelf.rotationAnimation()
                }
        }
    }
    
    
    /*循环引用：虽然利用ARC以及解决了内存自动释放的问题，程序员不用手动释放内存，但是如果a引用了b，b又引用a，那么会造成循环引用，导致ab都得不到释放。
     1.类循环引用的话，需要这样
     class B {
     weak var a: A? = nil  ----  这一步可以避免出现循环引用
     deinit {
     print("B deinit")
     }
     }
     2.闭包
     lazy var printName: ()->() = {
     [weak self] in    ------  采用添加标注的方式避免出现
     if let strongSelf = self {    ------  判断self是否被释放
     print("The name is \(strongSelf.name)")
     }
     }
     3.如果闭包有多个需要标注，unowned标注，表示整个过程中self都不会被释放，如果self被释放，那么会造成奔溃。
     // 标注前
     { (number: Int) -> Bool in
     //...
     return true
     }
     // 标注后
     { [unowned self, weak someObject] (number: Int) -> Bool in
     //...
     return true
     }
     */
    
    
    deinit {
        print("VC销毁了")
    }

}
