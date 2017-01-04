//
//  ScanVC.swift
//  QRCode
//
//  Created by baiwei－mac on 17/1/3.
//  Copyright © 2017年 YuHua. All rights reserved.
//

import UIKit
import AVFoundation

class ScanVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    
    //创建一个摄像头画面捕获类
    var session: AVCaptureSession?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        judgeCameraPermission()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //开始获取画面
        session?.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session?.stopRunning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //判断权限
    func judgeCameraPermission() {
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        //拒绝，受限制
        if status == AVAuthorizationStatus.restricted || status == AVAuthorizationStatus.denied {
            show(title: "没有权限使用！")
        }
        //没决定
        else if status == AVAuthorizationStatus.notDetermined {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (allow) in
                if allow {
                    print("同意了")
                    self.initSession()
                    self.initScanView()
                    self.session?.startRunning()
                }else {
                    print("拒绝了")
                    self.show(title: "被拒绝！无法使用！")
                }
            })
        }
        //允许
        else {
            initSession()
        }
    }
    
    
    func show(title: String) {
        print(title)
    }
    
    
    func setupView() {
        
        title = "扫描二维码"
        view.backgroundColor = .white
        view.addSubview(MaskView(frame: YHRect))
        if session != nil {
            initScanView()
        }
    }
    
    
    //初始化扫描区域
    func initScanView() {
        //用session生成一个AVCaptureVideoPreviewLayer添加到view的layer上，就会实时显示摄像头捕捉的内容
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        layer?.frame = YHRect
        view.layer.insertSublayer(layer!, at: 0)
    }
    
    
    //初始化session
    func initSession() {
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)//获取摄像头
        do {
            let input = try AVCaptureDeviceInput(device: device)//创建摄像头输入流
            let output = AVCaptureMetadataOutput()//创建输出流
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)//设置代理
            //设置扫描区域
            let widthS = 300/YHHeight
            let heightS = 300/YHWidth
            output.rectOfInterest = CGRect(x: (1-widthS)/2, y: (1-heightS)/2, width: widthS, height: heightS)
            session = AVCaptureSession()
            //采集率质量
            session?.sessionPreset = AVCaptureSessionPresetHigh
            session?.addInput(input)
            session?.addOutput(output)
            output.metadataObjectTypes = [AVMetadataObjectTypeQRCode,
                                          AVMetadataObjectTypeEAN13Code,
                                          AVMetadataObjectTypeEAN8Code,
                                          AVMetadataObjectTypeCode128Code]
        } catch let err as NSError {
            print("发生错误：\(err.localizedFailureReason)")
        }
    }
    
    deinit {
        print("\(self.description)销毁了")
    }
    
    //MARK: - AVCaptureMetadataOutputObjectsDelegate
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if metadataObjects.count > 0 {
            session?.stopRunning()
            let metadata = metadataObjects.first as! AVMetadataMachineReadableCodeObject
            let alert = UIAlertController(title: "扫描结果", message: metadata.stringValue!, preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
}



class MaskView: UIView {
    
    
    var lineLayer: CALayer!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black.withAlphaComponent(0.1)
        
        lineLayer = CALayer()
        lineLayer.frame = CGRect(x: (frame.width-300)/2, y: (frame.height-300)/2, width: 300, height: 2)
        lineLayer.contents = UIImage(named: "line")?.cgImage
        layer.addSublayer(lineLayer)
        resumeAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        let width: CGFloat = rect.size.width
        let height: CGFloat = rect.size.height
        let pickingWidth: CGFloat = 300
        let pickingHeight: CGFloat = 300
        
        let context = UIGraphicsGetCurrentContext()
        
        context!.saveGState()
        context!.setFillColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.35)
        let pickingRect = CGRect(x: (width-pickingWidth)/2, y: (height-pickingHeight)/2, width: pickingWidth, height: pickingHeight)
        //贝塞尔曲线合并到一起
        let pickingPath = UIBezierPath(rect: pickingRect)
        let bezierRect = UIBezierPath(rect: rect)
        bezierRect.append(pickingPath)
        //填充
        bezierRect.usesEvenOddFillRule = true
        bezierRect.fill()
        
        //画线
        context!.setLineWidth(2)
        context!.setStrokeColor(UIColor.orange.cgColor)
        pickingPath.stroke()
        
        context!.restoreGState()
        
        layer.contentsGravity = kCAGravityCenter
    }
    
    func stopAnimation() {
        lineLayer.removeAnimation(forKey: "translationY")
    }
    
    func resumeAnimation() {
        
        let basic = CABasicAnimation(keyPath: "transform.translation.y")
        basic.fromValue = 0
        basic.toValue = 300
        basic.duration = 2
        basic.repeatCount = Float(NSIntegerMax)
        lineLayer.add(basic, forKey: "translationY")
    }
    
    deinit {
        print("\(self.description)销毁了")
    }
}

