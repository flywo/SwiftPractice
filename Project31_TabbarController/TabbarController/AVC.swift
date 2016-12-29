//
//  AVC.swift
//  TabbarController
//
//  Created by baiwei－mac on 16/12/29.
//  Copyright © 2016年 YuHua. All rights reserved.
//

import UIKit

class AVC: UIViewController {
    
    let tableView = UITableView(frame: YHRect, style: .plain)
    let reuseIdentifer = String(describing: UITableViewCell.self)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        animateTable()
    }
    
    
    func animateTable() {
        
        let cells = tableView.visibleCells
        let height: CGFloat = YHHeight
        
        for i in cells {
            i.transform = CGAffineTransform(translationX: 0, y: height)
        }
        var index = 0
        for a in cells {
            UIView.animate(withDuration: 1, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [], animations: {
                a.transform = CGAffineTransform(translationX: 0, y: 0)
                }, completion: nil)
            index += 1
        }
    }
    
    
    func setupView() {
        
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifer)
        view.addSubview(tableView)
    }
}


extension AVC:UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath)
        cell.backgroundColor = UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1.0)
        return cell
    }
    
    
    //MARK: - Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 165
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
