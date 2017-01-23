//
//  ShowVC.swift
//  CookBook
//
//  Created by baiwei－mac on 17/1/23.
//  Copyright © 2017年 YuHua. All rights reserved.
//

import UIKit
import WebKit

class ShowVC: UIViewController {
    
    var ID = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupView() {
        let web = WKWebView(frame: YHNoNavRect)
        web.navigationDelegate = self
        view.addSubview(web)
        guard ID != 0 else {
            return
        }
        NetManager.share.HUDShow()
        web.load(URLRequest(url: URL(string: "http://wp.asopeixun.com/?p=\(ID)")!))
    }
   
}


extension ShowVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("开始加载网页")
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("加载网页到页面")
        NetManager.share.HUDHide()
    }
}
