//
//  CustomHeaderView.swift
//  MultilevelMenu
//
//  Created by baiwei－mac on 17/1/4.
//  Copyright © 2017年 YuHua. All rights reserved.
//

import UIKit

class CustomHeaderView: UITableViewHeaderFooterView {

    
    let imageView = UIImageView()
    let title = UILabel()
    let detail = UILabel()
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        imageView.contentMode = .center
        title.font = UIFont.systemFont(ofSize: 20)
        title.textAlignment = .left
        addSubview(imageView)
        addSubview(title)
        addSubview(detail)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: 0, y: 0, width: frame.height, height: frame.height)
        title.frame = CGRect(x: frame.height, y: 0, width: frame.width-2*frame.height, height: frame.height)
        detail.frame = CGRect(x: frame.width-frame.height, y: 0, width: frame.height, height: frame.height)
    }
    
    
    func buildUI(province: Province) {
        imageView.image = UIImage(named: province.isOpen ? "Down" : "Right")
        title.text = province.name
        detail.text = String(province.citys.count)+"个市"
    }
}
