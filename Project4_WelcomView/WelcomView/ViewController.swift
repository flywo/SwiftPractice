//
//  ViewController.swift
//  WelcomView
//
//  Created by baiwei－mac on 16/12/2.
//  Copyright © 2016年 YuHua. All rights reserved.
//

import UIKit

let YHRect = UIScreen.main.bounds
let YHHeight = YHRect.size.height
let YHWidth = YHRect.size.width

class ViewController: UIViewController, UIScrollViewDelegate {
    
    let scrollBG = UIScrollView(frame: YHRect)
    let images = ["first","second","three"]
    let pageControl = UIPageControl(frame: CGRect(x: 0, y: YHHeight-30, width: YHWidth, height: 20))
    var currentPage = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    func setupView() {
        //遍历数组，同时获得index
        for (index,value) in images.enumerated() {
            let imageView = UIImageView(frame: CGRect(x: YHWidth*CGFloat(index), y: 0, width: YHWidth, height: YHHeight))
            imageView.image = UIImage(named: value)
            //限制边界
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            scrollBG.addSubview(imageView)
        }
        scrollBG.delegate = self
        scrollBG.isPagingEnabled = true
        scrollBG.contentSize = CGSize(width: YHWidth*CGFloat(images.count), height: YHHeight)
        
        pageControl.currentPage = currentPage
        pageControl.numberOfPages = 3
        pageControl.isEnabled = false
        pageControl.pageIndicatorTintColor = .white
        pageControl.currentPageIndicatorTintColor = .gray
        
        view.addSubview(scrollBG)
        view.addSubview(pageControl)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let number = Int(round(scrollBG.contentOffset.x/YHWidth))
        /*由于swift是类型安全的，所以通过逻辑比较时，需要两边的类型相同，不同需要转换一下类型*/
        if  number >= 0 && number <= 2 && number != currentPage {
            currentPage = number
            pageControl.currentPage = currentPage
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

