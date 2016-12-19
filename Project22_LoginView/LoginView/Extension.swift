//
//  Extension.swift
//  LoginView
//
//  Created by baiwei－mac on 16/12/19.
//  Copyright © 2016年 YuHua. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func modificationTextField(placeholer: String, keyboardType: UIKeyboardType, text: String?) {
        self.placeholder = placeholer
        self.keyboardType = keyboardType
        self.text = text
        layer.cornerRadius = 5
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1
        textAlignment = .center
        clearButtonMode = .whileEditing
    }
}


extension UIButton {
    func modificationButton(title: String, BGColor: UIColor = .blue) {
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = BGColor
        layer.cornerRadius = 5
    }
}


extension Date {
    static func getCurrentTime() -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss:SSS"
        return format.string(from: date)
    }
}


/*调试打印输出，发布取消
 #file-文件名
 #function-函数名
 #line-行号
 */
func Log(_ message: Any) {
    #if DEBUG
        print("\(Date.getCurrentTime()) | \(#line) | \(URL(fileURLWithPath: #file).lastPathComponent) || \(message)")
    #endif
}
