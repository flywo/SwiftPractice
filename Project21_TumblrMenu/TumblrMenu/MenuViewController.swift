//
//  MenuViewController.swift
//  TumblrMenu
//
//  Created by baiwei－mac on 16/12/16.
//  Copyright © 2016年 YuHua. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    
    
    var btns = [UIButton]()
    let transitionManager = MenuTransitionManger()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func setupView() {
        transitioningDelegate = transitionManager
        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        let width: CGFloat = YHWidth/2
        let height: CGFloat = YHHeight/3
        let names = ["Audio","Chat","Link","Photo","Quote","Text"]
        for index in 0...5 {
            let rect = CGRect(x: width*CGFloat(index%2), y: height*CGFloat(index/2), width: width, height: height)
            let btn = UIButton(frame: rect)
            btn.setTitle(names[index], for: .normal)
            btn.setTitleColor(.white, for: .normal)
            btn.setImage(UIImage(named: names[index]), for: .normal)
            view.addSubview(btn)
            btn.alignContentVerticallyByCenter()
            btn.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
            btns.append(btn)
        }
    }
    
    func dismissView() {
        dismiss(animated: true, completion: nil)
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
