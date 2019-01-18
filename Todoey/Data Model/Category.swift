//
//  Category.swift
//  Todoey
//
//  Created by David Dörflinger on 17.01.19.
//  Copyright © 2019 David Dörflinger. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var bgColor: String = "" 
    let items = List<Item>()
}
