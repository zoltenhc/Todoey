//
//  Item.swift
//  Todoey
//
//  Created by Zoltán Gál
//

import Foundation
import RealmSwift

class Item : Object {
   @objc dynamic var title : String = ""
   @objc dynamic var done : Bool = false
   @objc dynamic var dateCreated : Date?
    @objc dynamic var itemColor : String = ""
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
