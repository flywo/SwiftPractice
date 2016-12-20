//
//  CustomCell.swift
//  SwipeableCell
//
//  Created by baiwei－mac on 16/12/20.
//  Copyright © 2016年 YuHua. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func buildInterface(model: CellModel) {
        imageView?.image = UIImage(named: model.imageName)
        textLabel?.text = model.title
        textLabel?.textAlignment = .center
    }

}


struct CellModel {
    let imageName: String
    var title: String
}

