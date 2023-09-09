//
//  Category.swift
//  Todoey
//
//  Created by Willian Bogarin Jr on 2023. 09. 08..
//  Copyright © 2023. App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @Persisted var name : String = ""
   @Persisted var items = List<Item>()
    @Persisted var categoryColor : String
    
}
