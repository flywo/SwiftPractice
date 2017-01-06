//
//  ViewController.swift
//  NetPictures
//
//  Created by baiwei－mac on 17/1/5.
//  Copyright © 2017年 YuHua. All rights reserved.
//

import UIKit
import MJRefresh//哪个文件使用，该文件就需要导入


let YHRect = UIScreen.main.bounds
let YHHeight = YHRect.size.height
let YHWidth = YHRect.size.width
let YHNoNavRect = CGRect(x: 0, y: 0, width: YHWidth, height: YHHeight - 64)
let YHNoTarRect = CGRect(x: 0, y: 0, width: YHWidth, height: YHHeight - 49)
let YHNoNavTarRect = CGRect(x: 0, y: 0, width: YHWidth, height: YHHeight - 49 - 64)


/*Xcode路径：
 $(SRCROOT)  项目根目录下
 $(PROJECT_DIR)  当前工程文件夹目录
 */


//妹子的数据
struct MMData {
    
    let nickname: String
    let height: String
    let weight: String
    let bwh: String
    let birthday: String
    let pictureCount: Int
    
    let headerUrl: String
    let headImageFilename: String
    let title: String
    let issue: Int
    let catalog: String
    let ID: Int
    
    
    static func parseData(data: Any?) -> [MMData] {
        
        var result = [MMData]()
        
        let dic = data as! NSDictionary
        let data = dic["data"] as! NSDictionary
        let list = data["list"] as! NSArray
        for mm in list {
            let mm = mm as! NSDictionary
            print(mm)
            let mmSource = mm["source"] as! NSDictionary
            let mmAuthor = mm["author"] as! NSDictionary
            let mmdata = MMData(nickname: mmAuthor["nickname"] as! String,
                                height: mmAuthor["height"] as! String,
                                weight: mmAuthor["weight"] as! String,
                                bwh: mmAuthor["bwh"] as! String,
                                birthday: mmAuthor["birthday"] as! String,
                                pictureCount: mm["pictureCount"] as! Int,
                                headerUrl: mmAuthor["headerUrl"] as! String,
                                headImageFilename: mm["headImageFilename"] as! String,
                                title: mm["title"] as! String,
                                issue: mm["issue"] as! Int,
                                catalog: mmSource["catalog"] as! String,
                                ID: mm["id"] as! Int)
            result.append(mmdata)
        }
        return result
    }
}




class ViewController: UIViewController {
    
    
    let tableView = UITableView(frame: YHRect, style: .plain)
    let reuseIdentifer = "Cell"
    var datas = [MMData]()
    var page = 1
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sendQuery()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func sendQuery() {
        HUDManager.hudShow(title: "正在更新", detail: "请稍后...")
        NetManager.postPage(page: page) { (result, error) in
            if error != nil {
                print("错误：\(error)")
                OperationQueue.main.addOperation {
                    HUDManager.removeShow()
                    self.tableView.mj_footer.endRefreshing()
                }
            }else {
                self.datas.append(contentsOf: MMData.parseData(data: result))
                //需要回到主线程刷新
                OperationQueue.main.addOperation {
                    self.tableView.reloadData()
                    self.page += 1
                    HUDManager.removeShow()
                    self.tableView.mj_footer.endRefreshing()
                }
            }
        }
    }

    
    func setupView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(CustomCell.self, forCellReuseIdentifier: reuseIdentifer)
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { 
            //刷新
            self.sendQuery()
        })
        view.addSubview(tableView)
    }
}




extension ViewController:UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer) as! CustomCell
        cell.buildUI(data: datas[indexPath.row])
        return cell
    }
    
    
    //MARK: - Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return YHWidth+80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


