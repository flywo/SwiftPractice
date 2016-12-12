//
//  WaveView.swift
//  WaveView
//
//  Created by baiwei－mac on 16/12/12.
//  Copyright © 2016年 YuHua. All rights reserved.
//

import UIKit

class WaveView: UIView {
    
    var waveSpeed: CGFloat = 1.8//速度
    var angularSpeed: CGFloat = 2.0//周期
    var waveColor: UIColor = .white//颜色
    
    private var waveDisplayLink: CADisplayLink?
    private var offsetX: CGFloat = 0.0
    /*CAShapeLayer:CALayer的子类，可以画出各种图形，配合UIBezierPath使用最好
     */
    private var waveShapeLayer: CAShapeLayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func stopWaver() {
        UIView.animate(withDuration: 1, animations: { 
            self.alpha = 0
            }) { (finished) in
                self.waveDisplayLink?.invalidate()
                self.waveDisplayLink = nil
                self.waveShapeLayer?.removeFromSuperlayer()
                self.waveShapeLayer = nil
                
                self.alpha = 1
        }
    }
    
    func startWave() {
        if waveShapeLayer != nil {
            return
        }
        
        waveShapeLayer = CAShapeLayer()
        waveShapeLayer?.fillColor = waveColor.cgColor
        layer.addSublayer(waveShapeLayer!)
        
        /*CADisplayLink:一个和屏幕刷新率相同的定时器，需要以特定的模式注册到runloop中，每次屏幕刷新时，会调用绑定的target上的selector这个方法。
         duration:每帧之间的时间
         pause:暂停，设置true为暂停，false为继续
         结束时，需要调用invalidate方法，并且从runloop中删除之前绑定的target跟selector。
         不能被继承
         */
        waveDisplayLink = CADisplayLink(target: self, selector: #selector(keyFrameWave))
        waveDisplayLink?.add(to: .main, forMode: .commonModes)
    }
    
    func keyFrameWave() {
        offsetX -= waveSpeed
        
        let width = frame.size.width
        let height = frame.size.height
        
        //创建path
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: height/2))
        
        var y: CGFloat = 0.0
        for x in stride(from: 0, through: width, by: 1) {
            y = height * sin(0.01 * (angularSpeed * x + offsetX))
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()
        
        waveShapeLayer?.path = path
    }

}
