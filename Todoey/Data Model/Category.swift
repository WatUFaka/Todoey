//
//  Category.swift
//  Todoey
//
//  Created by Eli gueta on 05/03/2019.
//  Copyright © 2019 Eli gueta. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    var items = List<Item>()
}
