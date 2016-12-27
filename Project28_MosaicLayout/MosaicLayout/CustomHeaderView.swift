//
//  CustomHeaderView.swift
//  MosaicLayout
//
//  Created by baiwei－mac on 16/12/26.
//  Copyright © 2016年 YuHua. All rights reserved.
//

import UIKit

class CustomHeaderView: UICollectionReusableView {
    
    let title = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        title.frame = bounds
        title.font = UIFont.systemFont(ofSize: 20)
        title.textColor = .orange
        title.textAlignment = .center
        addSubview(title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}
