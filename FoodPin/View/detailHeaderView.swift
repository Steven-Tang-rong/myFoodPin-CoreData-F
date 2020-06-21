//
//  detailHeaderView.swift
//  FoodPin
//
//  Created by TANG,QI-RONG on 2020/5/15.
//  Copyright © 2020 Steven. All rights reserved.
//

import UIKit

class detailHeaderView: UIView {

    @IBOutlet var headerImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!{
        didSet {
            nameLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet var typeLabel: UILabel!{
        didSet{
            typeLabel.layer.cornerRadius = 5.0
            typeLabel.layer.masksToBounds = true
            //需啟用masksToBounds屬性才有圓角
        }
    }
    
    @IBOutlet var heartImageView: UIImageView!
    
    @IBOutlet var ratingImageView: UIImageView!
    
}
