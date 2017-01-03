//
//  SearchResultTVC.swift
//  SearchVC
//
//  Created by baiwei－mac on 16/12/30.
//  Copyright © 2016年 YuHua. All rights reserved.
//

import UIKit

class SearchResultTVC: UITableViewController {
    
    
    let reuseIdentifer = "ResultCell"
    var datas = [Province]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer) ?? UITableViewCell(style: .default, reuseIdentifier: reuseIdentifer)
        cell.textLabel?.text = datas[indexPath.row].name
        cell.textLabel?.textColor = .orange
        return cell
    }

}
