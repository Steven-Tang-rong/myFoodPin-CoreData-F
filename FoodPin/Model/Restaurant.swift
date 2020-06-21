//
//  Restaurant.swift
//  FoodPin
//
//  Created by TANG,QI-RONG on 2020/5/13.
//  Copyright © 2020 Steven. All rights reserved.
//

import Foundation

class Restaurant {
    var name: String
    var location: String
    var type: String
    var Phone: String
    var description: String
    var image: String
    var isVisited: Bool
    var rating: String
    
    
    init(name: String, location: String, type: String, Phone: String, description: String, image: String, isVisited: Bool, rating: String = "") {
        self.name = name
        self.location = location
        self.type = type
        self.Phone = Phone
        self.description = description
        self.image = image
        self.isVisited = isVisited
        self.rating = rating
        
    }
    
    convenience init(){
        //必須與原init的順序一樣 (name～isVisited)
        self.init(name: "",location: "",type: "", Phone: "",description: "", image: "",isVisited: false)
    }
    
}


