//
//  Item.swift
//  Todoey
//
//  Created by Yon Thiri Aung on 7/5/19.
//  Copyright © 2019 Yon Thiri Aung. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var done : Bool = false
    @objc dynamic var title : String = ""
    @objc dynamic var dateCreated : Date?
    
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
