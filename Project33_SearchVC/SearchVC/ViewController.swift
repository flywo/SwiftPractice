//
//  ViewController.swift
//  SearchVC
//
//  Created by baiwei－mac on 16/12/30.
//  Copyright © 2016年 YuHua. All rights reserved.
//

import UIKit


//市区结构体，包含名字和别称
struct City {
    let name, alias: String
}

struct Province {
    var name: String
    var namePY: String
    var citys: [City]
}


let YHRect = UIScreen.main.bounds
let YHHeight = YHRect.size.height
let YHWidth = YHRect.size.width
let YHNoNavRect = CGRect(x: 0, y: 0, width: YHWidth, height: YHHeight - 64)
let YHNoTarRect = CGRect(x: 0, y: 0, width: YHWidth, height: YHHeight - 49)
let YHNoNavTarRect = CGRect(x: 0, y: 0, width: YHWidth, height: YHHeight - 49 - 64)


class ViewController: UIViewController {
    
    
    var searchController: UISearchController!
    var searchResultTC: SearchResultTVC!
    var datas = [Province]()
    let tableView = UITableView(frame: YHRect, style: .plain)
    let reuseIdentifer = "TableViewCell"


    override func viewDidLoad() {
        super.viewDidLoad()
        getPlistData()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    func setupView() {
        
        //tableView
        title = "所有省份"
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifer)
        view.addSubview(tableView)
        
        //search
        searchResultTC = SearchResultTVC(style: .plain)
        searchResultTC.tableView.delegate = self//将搜索结果的点击和本页点击绑定，点击效果一样
        
        searchController = UISearchController(searchResultsController: searchResultTC)
        //开始搜索时，是否关闭当前VC的控制功能，默认是true，为true，当开始搜索时，是无法控制当前VC的，false时，可以控制
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchResultsUpdater = self//设置刷新代理
        searchController.searchBar.sizeToFit()
        searchController.delegate = self
        searchController.searchBar.keyboardType = .default
        searchController.searchBar.placeholder = "可以输入拼音首字母进行搜索，比如：四川 SC"
        searchController.searchBar.delegate = self
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }
    
    func getPlistData() {
        
        let dic = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Province", ofType: "plist")!)
        dic?.enumerateKeysAndObjects({ (key, value, roolback) in
            let values = value as! NSDictionary
            var citys = [City]()
            for k in values.allKeys {
                let city = City(name: k as! String, alias: values[k] as! String)
                citys.append(city)
            }
            let pro = Province(name: key as! String, namePY: transformToPY(str: key as! String), citys: citys)
            datas.append(pro)
        })
    }
    
    //将数据转换成拼音
    func transformToPY(str: String) -> String {
        var py = NSMutableString(string: str)
        //转成拼音
        CFStringTransform(py as CFMutableString, nil, kCFStringTransformMandarinLatin, false)
        //去掉声母
        CFStringTransform(py as CFMutableString, nil, kCFStringTransformStripDiacritics, false)
        //获得每个汉字拼音首个大写字母
        let arr = py.components(separatedBy: " ")
        py = ""
        for str in arr {
            py.append(str.substring(to: str.index(after: str.startIndex)))
        }
        print(py)
        return py as String
    }
}


extension ViewController:UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    
    //MARK: - DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath)
        let data = datas[indexPath.row]
        cell.textLabel?.text = data.name
        cell.textLabel?.textColor = .orange
        return cell
    }
    
    //MARK: - Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let show = ShowVC()
        show.province = datas[indexPath.row]
        self.navigationController?.pushViewController(show, animated: true)
    }
    
    // MARK: - UISearchBarDelegate
    //搜索取消按钮被点击
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - UISearchControllerDelegate
    //推出搜索控制器
    func presentSearchController(_ searchController: UISearchController) {
    }
    
    //将要出现
    func willPresentSearchController(_ searchController: UISearchController) {
    }
    
    //已经出现
    func didPresentSearchController(_ searchController: UISearchController) {
    }
    
    //将要消失
    func willDismissSearchController(_ searchController: UISearchController) {
    }
    
    //已经消失
    func didDismissSearchController(_ searchController: UISearchController) {
    }
    
    // MARK: - UISearchResultsUpdating
    //更新搜索结果
    func updateSearchResults(for searchController: UISearchController) {
        
        let strIn = searchController.searchBar.text!
        print("输入：\(strIn)")
        /*Swift数组很重要的高阶函数：
         map:将每个元素通过某个方法进行转换成新的数组
            例子：stringsArray = moneyArray.map({"($0)?"})
                 stringsArray = moneyArray.map({money in "(money)?"})
         filter:选择满足某些条件的元素组成新的数组
            例子：filteredArray = moneyArray.filter({$0 > 30})
         reduce:把数组元组组合计算为一个值
            例子：sum = moneyArray.reduce(0,{$0 + $1})初始值0，元素相加
                 上面简写：sum = moneyArray.reduce(0,+)
         */
        let result = datas.filter({$0.namePY.contains(strIn.lowercased())||$0.name.contains(strIn)})
        print("搜索结果：\(result.count)")
        searchResultTC.datas = result
        searchResultTC.tableView.reloadData()
    }
}

