//
//  ViewController.swift
//  TableHeaderView
//
//  Created by baiwei－mac on 16/12/9.
//  Copyright © 2016年 YuHua. All rights reserved.
//

import UIKit

let YHRect = UIScreen.main.bounds
let YHHeight = YHRect.size.height
let YHWidth = YHRect.size.width

let HeadViewHeight = YHHeight/3.0

class ViewController: UIViewController {

    
    let datas = ["下","拉","可","以","出","现","很","神","奇","的","事","情","yo","yo","yo","yo","yo","yo"]
    let tableView = UITableView(frame: YHRect, style: .plain)
    let resueIdentifer = "CustomCell"
    let headView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: YHWidth, height: HeadViewHeight))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    func setupView() {
        self.automaticallyAdjustsScrollViewInsets = false
        
        headView.backgroundColor = .white
        headView.contentMode = .scaleAspectFill
        headView.clipsToBounds = true
        view.addSubview(headView)
        
        //加载图片
        let url = URL(string: "http://c.hiphotos.baidu.com/zhidao/pic/item/5ab5c9ea15ce36d3c704f35538f33a87e950b156.jpg")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let _ = data,error == nil else { return }
            //回到主线程
            DispatchQueue.main.sync {
                self.headView.image = UIImage(data: data!)
            }
        }
        task.resume()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: resueIdentifer)
        tableView.showsVerticalScrollIndicator = false
        //下面两句必不可少，否则会出现第一次加载时位置不对的情况
        tableView.contentInset.top = HeadViewHeight
        tableView.contentOffset = CGPoint(x: 0.0, y: -HeadViewHeight)
//        tableView.scrollIndicatorInsets.top = HeadViewHeight//右边指示器的位置
        view.addSubview(tableView)
        view.sendSubview(toBack: tableView)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: resueIdentifer, for: indexPath)
        cell.textLabel?.text = datas[indexPath.row]
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    //MARK: - Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsety = scrollView.contentOffset.y + scrollView.contentInset.top
        if offsety <= 0 {
            headView.frame = CGRect(x: 0.0, y: 0.0, width: YHWidth, height: HeadViewHeight-offsety)
        }else {
            let height = (HeadViewHeight-offsety) <= 0.0 ? 0.0 : (HeadViewHeight-offsety)
            headView.frame = CGRect(x: 0.0, y: 0.0, width: YHWidth, height: height)
            headView.alpha = height/HeadViewHeight
        }
    }
}

