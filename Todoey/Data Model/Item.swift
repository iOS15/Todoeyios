//
//  Item.swift
//  Todoey
//
//  Created by David Dörflinger on 17.01.19.
//  Copyright © 2019 David Dörflinger. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
