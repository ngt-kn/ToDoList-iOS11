//
//  Category.swift
//  ToDoList
//
//  Created by Kenneth Nagata on 5/11/18.
//  Copyright © 2018 Kenneth Nagata. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
