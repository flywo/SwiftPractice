//
//  NetManager.swift
//  CookBook
//
//  Created by baiwei－mac on 17/1/22.
//  Copyright © 2017年 YuHua. All rights reserved.
//

import Foundation
import Alamofire
import PKHUD

//首页URL
let mainURL = "http://wp.asopeixun.com:5000/get_post_from_category_id?category_id=159"
//菜系列表
let mainMenuURL = "http://wp.asopeixun.com:5000/get_category_list?app_id=1123413756"


enum DataType {
    case MainData
    case MenuData
}


protocol NetDelegate {
    func dataDownload<DATA>(datas: [DATA]?, type: DataType)
}


class NetManager {
    
    var delegates = [NetDelegate]()
    
    static let share = NetManager()
    
    private init() {}
    
    //首页
    func mainData(url: String) {
        self.HUDShow()
        Alamofire.request(URL(string: url)!).responseJSON {response in
//            print(response.request)  // original URL request
//            print(response.response) // HTTP URL response
//            print(response.data)     // server data
//            print(response.result)   // result of response serialization
            if let JSON = response.result.value {
                let datas = ShowData.parseData(data: JSON)
                if let datas = datas {
                    _ = self.delegates.map{$0.dataDownload(datas: datas, type: .MainData)}
                }
            }
        }
    }
    
    //菜系列表
    func menuData() {
        self.HUDShow()
        Alamofire.request(URL(string: mainMenuURL)!).responseJSON { response in
            guard let JSON = response.result.value else { return }
            let datas = MenuData.parseData(data: JSON)
            _ = self.delegates.map{$0.dataDownload(datas: datas, type: .MenuData)}
        }
    }
    
    //下载图片
    func downImage(imageView: UIImageView, imageURL: URL) {
        Alamofire.request(imageURL).responseData { response in
            guard let data = response.data else { return }
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data)
            }
        }
    }
    
    func HUDShow() {
        HUD.show(.labeledProgress(title: "正在获取数据", subtitle: "请稍后..."))
        HUD.hide(afterDelay: 10) { _ in
            HUD.flash(.error, delay: 1)
        }
    }
    
    func HUDHide() {
        HUD.hide()
    }
}

