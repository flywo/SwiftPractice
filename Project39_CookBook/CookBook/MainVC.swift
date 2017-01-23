//
//  MainVC.swift
//  CookBook
//
//  Created by baiwei－mac on 17/1/20.
//  Copyright © 2017年 YuHua. All rights reserved.
//

import UIKit
import SideMenu


struct ShowData {
    var jianjie: String
    var tags: String
    var thumb_2: String
    var views: NSInteger
    var title: String
    var thumb: String
    var ID: NSInteger
    var catename: String
    var subcatename: String
    var edittime: String
    var menuTitle: String
    
    static func parseData(data: Any?) -> [ShowData]? {
        if let data = data {
            var result = [ShowData]()
            let dic = data as! NSDictionary
            let arr = dic["list"] as! NSArray
            for content in arr {
                let dic = content as! NSDictionary
                let arr = dic["list"] as! NSArray
                let title = dic["title"] as! String
                for content in arr {
                    let dic = content as! NSDictionary
                    let menu = ShowData(jianjie: dic["jianjie"] as! String,
                                        tags: dic["tags"] as! String,
                                        thumb_2: dic["thumb_2"] as! String,
                                        views: dic["views"]! as! NSInteger,
                                        title: dic["title"] as! String,
                                        thumb: dic["thumb"] as! String,
                                        ID: dic["ID"]! as! NSInteger,
                                        catename: dic["catename"] as! String,
                                        subcatename: dic["subcatename"] as! String,
                                        edittime: dic["edittime"] as! String,
                                        menuTitle: title)
                    result.append(menu)
                }
                return result
            }
        }
        return nil
    }
}


class MainVC: UIViewController {
    
    
    let tableView = UITableView(frame: YHNoNavRect, style: .plain)
    let reuseIdentifer = "MainCell"
    var datas = [ShowData]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        NetManager.share.mainData(url: mainURL)
        NetManager.share.delegates.append(self)
        configSideMenu()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupView() {
        title = "菜谱"
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .done, target: self, action: #selector(showSideMunu))
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "bgimg"), for: .topAttached, barMetrics: .default)
        navigationController?.navigationBar.barStyle = .black//如果有导航栏，需要设置状态栏颜色，需要通过该方法实现
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(MainCustomCell.self, forCellReuseIdentifier: reuseIdentifer)
        view.addSubview(tableView)
    }
    
    func showSideMunu() {
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    func configSideMenu() {
        let menu = UISideMenuNavigationController(rootViewController: ViewController())
        menu.leftSide = true
        SideMenuManager.menuLeftNavigationController = menu
        SideMenuManager.menuFadeStatusBar = false
        SideMenuManager.menuPresentMode = .viewSlideInOut
        SideMenuManager.menuAnimationFadeStrength = 0.5//隐藏度
        SideMenuManager.menuShadowOpacity = 0.5//阴影透明度
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
    }

}


extension MainVC:UITableViewDataSource, UITableViewDelegate, NetDelegate {
    
    //MARK: - DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! MainCustomCell
        cell.buildUI(data: datas[indexPath.row])
        return cell
    }
    
    
    //MARK: - Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = datas[indexPath.row]
        let show = ShowVC()
        show.ID = data.ID
        show.title = data.title
        navigationController?.pushViewController(show, animated: true)
    }
    
    
    //MARK: - NetDelegate
    func dataDownload<DATA>(datas: [DATA]?, type: DataType) {
        guard let datas = datas, type == DataType.MainData else {
            return
        }
        self.datas.removeAll()
        for data in datas {
            self.datas.append(data as! ShowData)
        }
        DispatchQueue.main.async {
            let data = self.datas.first
            self.title = data?.menuTitle
            self.tableView.reloadData()
            NetManager.share.HUDHide()
        }
    }
}



class MainCustomCell: UITableViewCell {
    
    let title = UILabel()
    let detail = UILabel()
    let showImage = UIImageView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        showImage.frame = CGRect(x: 10, y: 10, width: 60, height: 60)
        title.frame = CGRect(x: 80, y: 10, width: YHWidth-80-40, height: 40)
        title.font = UIFont.systemFont(ofSize: 16)
        title.numberOfLines = 0
        title.textColor = .black
        detail.frame = CGRect(x: 80, y: 50, width: YHWidth-80-40, height: 20)
        detail.font = UIFont.systemFont(ofSize: 12)
        detail.textColor = .gray
        accessoryType = .disclosureIndicator
        
        addSubview(showImage)
        addSubview(detail)
        addSubview(title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildUI(data: ShowData) {
        title.text = data.title
        detail.text = data.jianjie
        NetManager.share.downImage(imageView: showImage, imageURL: URL(string: data.thumb)!)
    }
    
}


