//
//  Category.swift
//  Todoey
//
//  Created by Yon Thiri Aung on 7/5/19.
//  Copyright © 2019 Yon Thiri Aung. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name : String = ""
    let items = List<Item>() 
    
}
