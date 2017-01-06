//
//  CustomCell.swift
//  NetPictures
//
//  Created by baiwei－mac on 17/1/5.
//  Copyright © 2017年 YuHua. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    
    let nickname = UILabel()
    let detail = UILabel()
    let headerImage = UIImageView()
    let showImage = UIImageView()
    let title = UILabel()
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        headerImage.frame = CGRect(x: 10, y: 10, width: 40, height: 40)
        headerImage.contentMode = .scaleAspectFill
        headerImage.layer.cornerRadius = 20
        headerImage.clipsToBounds = true
        
        nickname.frame = CGRect(x: 60, y: 10, width: YHWidth-60, height: 20)
        nickname.font = UIFont.systemFont(ofSize: 18)
        nickname.textColor = .black
        
        detail.frame = CGRect(x: 60, y: 30, width: YHWidth-60, height: 20)
        detail.font = UIFont.systemFont(ofSize: 12)
        detail.adjustsFontSizeToFitWidth = true
        detail.textColor = .gray
        
        title.frame = CGRect(x: 10, y: 60, width: YHWidth-20, height: 20)
        title.font = UIFont.systemFont(ofSize: 18)
        title.adjustsFontSizeToFitWidth = true
        title.textColor = .black
        
        showImage.frame = CGRect(x: 10, y: 90, width: YHWidth-20, height: YHWidth-20)
        showImage.contentMode = .scaleAspectFill
        showImage.clipsToBounds = true
        
        addSubview(headerImage)
        addSubview(nickname)
        addSubview(detail)
        addSubview(title)
        addSubview(showImage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildUI(data: MMData) {
        
        headerImage.setImageWith(URL(string: "\(HeadImage)\(data.headerUrl)")!, placeholderImage: UIImage(named: "placeholder"))
        nickname.text = data.nickname
        detail.text = "生日：\(data.birthday) 三围：\(data.bwh) 身高：\(data.height) 体重：\(data.weight)"
        title.text = "\(data.title)"
        showImage.setImageWith(URL(string: "\(ImageHead)\(data.catalog)/\(data.issue)/\(data.headImageFilename)")!, placeholderImage: UIImage(named: "placeholder"))
    }

}
