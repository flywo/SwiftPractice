//
//  MenuTransitionManger.swift
//  TumblrMenu
//
//  Created by baiwei－mac on 16/12/16.
//  Copyright © 2016年 YuHua. All rights reserved.
//

import UIKit

class MenuTransitionManger: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {

    
    private var presenting = false

    
    func offStage(amount: CGFloat) -> CGAffineTransform {
        //返回平移x,y的结构体
        return CGAffineTransform(translationX: amount, y: 0)
    }
    
    //关
    func offStageMenuController(menuVC: MenuViewController) {
        menuVC.view.alpha = 0
        
        let topRowOffset: CGFloat = 300
        let middleRowOffset: CGFloat = 150
        let bottomRowOffset: CGFloat = 50
        
        menuVC.btns[0].transform = offStage(amount: -topRowOffset)
        menuVC.btns[1].transform = offStage(amount: topRowOffset)
        menuVC.btns[2].transform = offStage(amount: -middleRowOffset)
        menuVC.btns[3].transform = offStage(amount: middleRowOffset)
        menuVC.btns[4].transform = offStage(amount: -bottomRowOffset)
        menuVC.btns[5].transform = offStage(amount: bottomRowOffset)
    }
    
    //开
    func onStageMenuController(menuVC: MenuViewController) {
        menuVC.view.alpha = 1
        
        menuVC.btns[0].transform = CGAffineTransform.identity
        menuVC.btns[1].transform = CGAffineTransform.identity
        menuVC.btns[2].transform = CGAffineTransform.identity
        menuVC.btns[3].transform = CGAffineTransform.identity
        menuVC.btns[4].transform = CGAffineTransform.identity
        menuVC.btns[5].transform = CGAffineTransform.identity
    }
    
    //MARK: - UIViewControllerAnimatedTransitioning
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let screens: (from: UIViewController, to: UIViewController) = (transitionContext.viewController(forKey: .from)!, transitionContext.viewController(forKey: .to)!)
        let menuVC = !presenting ? screens.from as! MenuViewController : screens.to as! MenuViewController
        let bottomVC = !presenting ? screens.to : screens.from
        let menuV = menuVC.view
        let bottomV = bottomVC.view
        
        if self.presenting {
            offStageMenuController(menuVC: menuVC)
        }
        
        container.addSubview(bottomV!)
        container.addSubview(menuV!)
        
        let duration = self.transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration,
                       delay: 0.0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.8,
                       options: [],
                       animations: { 
                        self.presenting ? self.onStageMenuController(menuVC: menuVC) : self.offStageMenuController(menuVC: menuVC)
            },
                       completion: { finished in
                        transitionContext.completeTransition(true)
                        if self.presenting {
                            UIApplication.shared.keyWindow?.addSubview(screens.from.view)
                        }
                        UIApplication.shared.keyWindow?.addSubview(screens.to.view)
            }
        )
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    
    //MARK: - UIViewControllerTransitioningDelegate
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = false
        return self
    }

}
