//
//  ViewController.swift
//  SimpleClock
//
//  Created by baiwei－mac on 16/11/30.
//  Copyright © 2016年 YuHua. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let showLable = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: YHScreenWidth, height: YHScreenHeight/2))
    let beign = UIButton(frame: CGRect(x: 0.0, y: YHScreenHeight/2, width: YHScreenWidth/2, height: YHScreenHeight/2))
    let pause = UIButton(frame: CGRect(x: YHScreenWidth/2, y: YHScreenHeight/2, width: YHScreenWidth/2, height: YHScreenHeight/2))
    var time : Timer?
    var n = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white//背景色
        
        //添加界面
        setupView()
    }
    
    func setupView(){
        showLable.backgroundColor = .yellow
        beign.backgroundColor = .orange
        pause.backgroundColor = .blue
        beign.setTitle("开始", for: .normal)
        beign.setTitle("结束", for: .selected)
        pause.setTitle("暂停", for: .normal)
        pause.setTitle("继续", for: .selected)
        [beign,pause].forEach{
            ($0.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside))
        }
        /*
         bumbers.sort{(first,second) in 
            return first > second
         }
         等价
         bumbers.sort{$0 > $1}
         */
        showLable.text = "0"
        showLable.textColor = .white
        showLable.font = UIFont.systemFont(ofSize: YHScreenHeight/4, weight: YHScreenWidth/4)
        showLable.textAlignment = .center
        view.addSubview(showLable)
        view.addSubview(beign)
        view.addSubview(pause)
    }
    
    func buttonTapped(sender: UIButton) {
        switch sender {
        case beign:
            beign.isSelected = !beign.isSelected
            beign.isSelected ? beginSC() : stopSC()
        case pause:
            pause.isSelected = !pause.isSelected
            pause.isSelected ? pauseSC() : continSC()
            
        default:
            break
        }
    }
    
    // MARK: - 操作
    // TODO: - 记得做
    // FIXME: - 提醒
    
    func beginSC() {
        time = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(changeLabel), userInfo: nil, repeats: true)
    }
    func stopSC() {
        showLable.text = "0"
        time?.invalidate()
        time = nil
    }
    func pauseSC() {
        if !beign.isSelected {
            return
        }
        time?.invalidate()
        time = nil
    }
    func continSC() {
        if !beign.isSelected {
            return
        }
        beginSC()
    }
    func changeLabel() {
        n += 1
        showLable.text = String(n)
        //s = "\(x)" | toString(x) | x.description
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

