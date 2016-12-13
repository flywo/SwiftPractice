//
//  ShapeLayerAnimation.swift
//  ShapeLayerAnimation
//
//  Created by baiwei－mac on 16/12/13.
//  Copyright © 2016年 YuHua. All rights reserved.
//

import UIKit

class ShapeLayerAnimation: UIViewController ,CAAnimationDelegate {
    
    let centerX: Double = 200.0
    let centerY: Double = 300.0
    
    
    private let shapeLayer = CAShapeLayer()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ShapeLayer动画"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupView() {
        shapeLayer.fillColor = UIColor.clear.cgColor//填充颜色
        shapeLayer.lineWidth = 20.0//线条宽度
        shapeLayer.lineCap = "round"//线条风格
        shapeLayer.lineJoin = "round"//连接风格
        shapeLayer.strokeColor = UIColor.red.cgColor//相当于线条颜色
        view.layer.addSublayer(shapeLayer)
        
        //贝塞尔曲线
        let path = UIBezierPath(arcCenter: CGPoint(x: centerX, y: centerY), radius: 80, startAngle: 0, endAngle: CGFloat(M_PI*2), clockwise: false)
        //关联layer和贝塞尔曲线
        shapeLayer.path = path.cgPath
        //创建动画，strokeEnd属性
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        shapeLayer.autoreverses = false
        animation.duration = 3.0
        
        //设置动画
        shapeLayer.add(animation, forKey: nil)
        animation.delegate = self
        
        //外围16根线条
        let count = 16
        for i in 0..<count {
            let line = CAShapeLayer()
            line.fillColor = UIColor.clear.cgColor
            line.strokeColor = UIColor.yellow.cgColor
            line.lineWidth = 15.0
            line.lineCap = "round"
            line.lineJoin = "round"
            view.layer.addSublayer(line)
            
            let path2 = UIBezierPath()
            let x = centerX+100*cos(2.0*Double(i)*M_PI/Double(count))
            let y = centerY-100*sin(2.0*Double(i)*M_PI/Double(count))
            let len = 50
            path2.move(to: CGPoint(x: x, y: y))
            path2.addLine(to: CGPoint(x: x+Double(len)*cos(2*M_PI/Double(count)*Double(i)), y: y-Double(len)*sin(2*M_PI/Double(count)*Double(i))))
            line.path = path2.cgPath
            line.add(animation, forKey: nil)
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        //结束后设置整个填充为红色
        shapeLayer.fillColor = UIColor.red.cgColor
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
