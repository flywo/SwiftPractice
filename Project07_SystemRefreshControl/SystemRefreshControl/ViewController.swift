//
//  ViewController.swift
//  SystemRefreshControl
//
//  Created by baiwei－mac on 16/12/7.
//  Copyright © 2016年 YuHua. All rights reserved.
//

import UIKit

let YHRect = UIScreen.main.bounds
let YHHeight = YHRect.size.height
let YHWidth = YHRect.size.width

class ViewController: UIViewController {
    
    
    let tableView = UITableView(frame: YHRect, style: .plain)
    let refreshControl = UIRefreshControl()
    
    var contents = ["下下下下下","拉拉拉拉拉","刷刷刷刷刷","新新新新新","哟哟哟哟哟"]
    let news = ["1111","2222","3333","4444","5555","6666"]
    let cellIdentifier = "RefreshCell"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupView() {
        
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        tableView.refreshControl = refreshControl
        refreshControl.backgroundColor = .gray
        refreshControl.attributedTitle = NSAttributedString(string: "最后一次更新：\(NSDate())",attributes: [NSForegroundColorAttributeName: UIColor.white])//文字的颜色
        refreshControl.tintColor = .orange//菊花的颜色
        refreshControl.addTarget(self, action: #selector(addContent), for: .valueChanged)
        
        view.addSubview(tableView)
    }
    
    func addContent() {
        contents.append(contentsOf: news)
        tableView.reloadData()
        refreshControl.endRefreshing()
    }

}

//将代理写到扩展里面
extension ViewController:UITableViewDataSource, UITableViewDelegate {
    //MARK: - DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        cell.textLabel?.text = String(indexPath.row+1) + ":" + contents[indexPath.row]
        cell.textLabel?.textColor = .black
        cell.textLabel?.backgroundColor = .clear
        cell.textLabel?.font = UIFont.systemFont(ofSize: 30, weight: 10)
        return cell
    }
    
    //MARK: - Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

