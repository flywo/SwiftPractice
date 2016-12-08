//
//  ViewController.swift
//  VideoBackground
//
//  Created by baiwei－mac on 16/12/8.
//  Copyright © 2016年 YuHua. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer

let YHRect = UIScreen.main.bounds
let YHHeight = YHRect.size.height
let YHWidth = YHRect.size.width

let loginBtnRect = CGRect(x: 30, y: YHHeight-150, width: YHWidth-60, height: 50)
let regisBtnRect = CGRect(x: 30, y: YHHeight-75, width: YHWidth-60, height: 50)

class ViewController: UIViewController, AVPlayerViewControllerDelegate {
    
    
    let playerVC = AVPlayerViewController()
    let loginBtn = UIButton(frame: loginBtnRect)
    let regisBtn = UIButton(frame: regisBtnRect)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setMoviePlayer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setMoviePlayer() {
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "moments", ofType: "mp4")!)
        playerVC.player = AVPlayer(url: url)//指定播放源
        playerVC.showsPlaybackControls = false//是否显示工具栏
        playerVC.videoGravity = AVLayerVideoGravityResizeAspectFill//视频画面适应方式
        playerVC.view.frame = YHRect
        playerVC.view.alpha = 0
        //监听视频播放完的状态
        NotificationCenter.default.addObserver(self, selector: #selector(repeatPlay), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerVC.player?.currentItem)
        view.addSubview(playerVC.view)
        view.sendSubview(toBack: playerVC.view)//放到最底层
        UIView.animate(withDuration: 1) {
            self.playerVC.view.alpha = 1;
            self.playerVC.player?.play()
        }
    }
    //回到起点，重新播放
    func repeatPlay() {
        playerVC.player?.seek(to: kCMTimeZero)
        playerVC.player?.play()
    }
    func setupView() {
        view.backgroundColor = .white
        loginBtn.customBtn(customTitle: "登录")
        regisBtn.customBtn(customTitle: "注册")
        
        loginBtn.addTarget(self, action: #selector(buttonTap(_:)), for: .touchUpInside)
        regisBtn.addTarget(self, action: #selector(buttonTap(_:)), for: .touchUpInside)
        
        view.addSubview(loginBtn)
        view.addSubview(regisBtn)
    }
    func buttonTap(_ sender: UIButton) {
        print("点击的按钮："+sender.currentTitle!)
    }
}

