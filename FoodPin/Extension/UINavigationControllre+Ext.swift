//
//  UINavigationControllre+Ext.swift
//  FoodPin
//
//  Created by TANG,QI-RONG on 2020/5/24.
//  Copyright © 2020 Steven. All rights reserved.
//

import UIKit

extension UINavigationController {
    open override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
}
