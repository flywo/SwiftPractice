//
//  ViewController.swift
//  BasicAnimation
//
//  Created by baiwei－mac on 16/12/27.
//  Copyright © 2016年 YuHua. All rights reserved.
//

import UIKit


let YHRect = UIScreen.main.bounds
let YHHeight = YHRect.size.height
let YHWidth = YHRect.size.width
let YHNoNavRect = CGRect(x: 0, y: 0, width: YHWidth, height: YHHeight - 64)
let YHNoTarRect = CGRect(x: 0, y: 0, width: YHWidth, height: YHHeight - 49)
let YHNoNavTarRect = CGRect(x: 0, y: 0, width: YHWidth, height: YHHeight - 49 - 64)


class ViewController: UIViewController {

    let datas = ["位置","透明度","缩放","颜色","旋转"]
    let tableView = UITableView(frame: YHRect, style: .plain)
    let reuseIdentifer = String(describing: UITableViewCell.self)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func setupView() {
        
        title = "动画"
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifer)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath)
        cell.textLabel?.text = datas[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 30, weight: 5)
        cell.textLabel?.textColor = .orange
        return cell
    }
    
    
    //MARK: - Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = AnimationViewController()
        vc.title = tableView.cellForRow(at: indexPath)?.textLabel?.text
        switch indexPath.row {
        case 0:
            vc.animationStyle = "Position"
        case 1:
            vc.animationStyle = "Opacity"
        case 2:
            vc.animationStyle = "Scale"
        case 3:
            vc.animationStyle = "Color"
        default:
            vc.animationStyle = "Rotation"
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

