//
//  ViewController.swift
//  MultilevelMenu
//
//  Created by baiwei－mac on 17/1/4.
//  Copyright © 2017年 YuHua. All rights reserved.
//

import UIKit


let YHRect = UIScreen.main.bounds
let YHHeight = YHRect.size.height
let YHWidth = YHRect.size.width
let YHNoNavRect = CGRect(x: 0, y: 0, width: YHWidth, height: YHHeight - 64)
let YHNoTarRect = CGRect(x: 0, y: 0, width: YHWidth, height: YHHeight - 49)
let YHNoNavTarRect = CGRect(x: 0, y: 0, width: YHWidth, height: YHHeight - 49 - 64)


struct City {
    
    let name: String
    let alias: String
}


struct Province {
    
    let name: String
    var citys: [City]
    var isOpen: Bool
}


class ViewController: UIViewController {
    
    
    let tableView = UITableView(frame: YHRect, style: .plain)
    let reuseIdentifer = "Cell"
    let reuseHeaderIdentifer = "HeaderCell"
    var datas = [Province]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initDatas()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func initDatas() {
        
        let dic = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Province", ofType: "plist")!)
        dic?.enumerateKeysAndObjects({ (key, value, roolback) in
            let values = value as! NSDictionary
            var citys = [City]()
            for k in values.allKeys {
                let city = City(name: k as! String, alias: values[k] as! String)
                citys.append(city)
            }
            let pro = Province(name: key as! String, citys: citys, isOpen: false)
            datas.append(pro)
        })
    }
    
    
    func setupView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(CustomHeaderView.self, forHeaderFooterViewReuseIdentifier: reuseHeaderIdentifer)
        view.addSubview(tableView)
    }
}


extension ViewController:UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let province = datas[section]
        return province.isOpen ? province.citys.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer) ?? UITableViewCell(style: .value1, reuseIdentifier: reuseIdentifer)
        let city = datas[indexPath.section].citys[indexPath.row]
        cell.textLabel?.text = city.name
        cell.textLabel?.textColor = .orange
        cell.textLabel?.textAlignment = .center
        cell.detailTextLabel?.text = city.alias
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseHeaderIdentifer) as! CustomHeaderView
        
        func addTap() {
            let tap = UITapGestureRecognizer(target: self, action: #selector(headerTap(sender:)))
            tap.tag = section
            view.addGestureRecognizer(tap)
        }
        
        print("手势数目：\(view.gestureRecognizers?.count)")
        if let grs = view.gestureRecognizers {
            grs.count > 0 ? (grs.first as! UITapGestureRecognizer).tag = section : addTap()
        }else {
            addTap()
        }
        view.buildUI(province: datas[section])
        return view
    }
    
    //MARK: - GR
    func headerTap(sender: UITapGestureRecognizer) {
        
        datas[sender.tag].isOpen = !datas[sender.tag].isOpen
        tableView.reloadSections([sender.tag], with: .fade)
    }
    
    //MARK: - Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


//采用runtime为手势增加一个tag属性，标记手势。
extension UITapGestureRecognizer {
    
    struct AddProperty {
        static var tag: Int = 0
    }
    
    var tag: Int {
        get {
            return objc_getAssociatedObject(self, &AddProperty.tag) as! Int
        }
        set {
            objc_setAssociatedObject(self, &AddProperty.tag, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}

