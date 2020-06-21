//
//  RoundedTextField.swift
//  FoodPin
//
//  Created by TANG,QI-RONG on 2020/6/1.
//  Copyright © 2020 Steven. All rights reserved.
//

import UIKit

class RoundedTextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    //此方法所回傳的繪製矩形是針對文字欄位文字
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    //此方法所回傳的繪製矩形是針對文字欄位『佔位符』文字
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    //此方法所回傳的矩形適用於顯示可編輯文字
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 7.0
        self.layer.masksToBounds = true
    }
}
