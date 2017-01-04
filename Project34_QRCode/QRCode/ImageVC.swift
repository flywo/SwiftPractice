//
//  ImageVC.swift
//  QRCode
//
//  Created by baiwei－mac on 17/1/3.
//  Copyright © 2017年 YuHua. All rights reserved.
//

import UIKit

class ImageVC: UIViewController {
    
    
    let imageView = UIImageView(frame: CGRect(x: 20, y: 100, width: YHWidth-40, height: YHWidth-40))
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func setupView() {
        
        title = "识别二维码图片"
        view.backgroundColor = .white
        
        imageView.image = UIImage(named: "pic")
        imageView.isUserInteractionEnabled = true
        view.addSubview(imageView)
        
        let label = UILabel(frame: CGRect(x: 0, y: imageView.frame.origin.y+YHWidth, width: YHWidth, height: 20))
        label.text = "长按图片识别"
        label.textColor = .orange
        label.textAlignment = .center
        view.addSubview(label)
        
        let long = UILongPressGestureRecognizer(target: self, action: #selector(longHandle(sender:)))
        imageView.addGestureRecognizer(long)
    }
    
    func longHandle(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            /*CIDetector：iOS自带的识别图片的类*/
            let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])
            let arr = detector?.features(in: CIImage(cgImage: (imageView.image?.cgImage)!))
            var detail = ""
            if (arr?.count)! > 0 {
                detail = (arr?.first as! CIQRCodeFeature).messageString!
            }else {
                detail = "未扫描到结果！"
            }
            let alert = UIAlertController(title: "扫描结果", message: detail, preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    deinit {
        print("\(self.description)销毁了")
    }
}
