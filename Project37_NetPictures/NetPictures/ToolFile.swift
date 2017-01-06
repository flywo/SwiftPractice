//
//  NetManager.swift
//  NetPictures
//
//  Created by baiwei－mac on 17/1/5.
//  Copyright © 2017年 YuHua. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD


//数据是网上抓来的，只用于学习用，请勿用于别用！
let MainHeader = "http://api.pmkoo.cn/aiss/suite/suiteList.do" //POST body: page 1 
let HeadImage = "http://com-pmkoo-img.oss-cn-beijing.aliyuncs.com/header/" //GET + headerUrl
let ImageHead = "http://com-pmkoo-img.oss-cn-beijing.aliyuncs.com/picture/" //GET + catalog + issue + headImageFileName


class NetManager: NSObject {

    static func postPage(page: Int, finished: @escaping ((_ result: Any?, _ error: Error?)->())) {
        
        //成功回调
        let successCallBack = {(task : URLSessionDataTask, result : Any?) -> Void in
            finished(result, nil)
        }
        
        //失败回调
        let errorCallBack = {(task : URLSessionDataTask?, error : Error) -> Void in
            finished(nil, error)
        }
        
        AFHTTPSessionManager().post(MainHeader,
                                    parameters: ["page": page],
                                    progress: nil,
                                    success: successCallBack,
                                    failure: errorCallBack)
    }
}




class HUDManager: NSObject {
    
    
    //记录下正在显示的HUD
    static var show: MBProgressHUD?
    
    
    //一直显示，直到移除
    static func hudShow(title: String, detail: String) {
        
        if let hud = show {
            hud.hide(animated: true)
        }
        
        show = MBProgressHUD(view: UIApplication.shared.keyWindow!)
        UIApplication.shared.keyWindow?.addSubview(show!)
        
        show?.label.text = title
        show?.label.font = UIFont.systemFont(ofSize: 13)
        show?.detailsLabel.text = detail
        show?.detailsLabel.font = UIFont.systemFont(ofSize: 11)
        show?.isSquare = true
        show?.removeFromSuperViewOnHide = true
        show?.show(animated: true)
    }
    
    //移除HUD
    static func removeShow() {
        
        if let hud = show {
            hud.hide(animated: true)
        }
    }
    
    //无图提示框
    static func hudShowWithPic(detail: String, continueTime: TimeInterval) {
        
        if let hud = show {
            hud.hide(animated: true)
        }
        
        show = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
        show?.mode = .text
        show?.label.text = detail
        show?.margin = 15
        show?.label.font = UIFont.systemFont(ofSize: 12)
        show?.removeFromSuperViewOnHide = true
        show?.hide(animated: true, afterDelay: continueTime)
    }
}
