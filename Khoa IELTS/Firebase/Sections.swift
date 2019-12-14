//
//  Sections.swift
//  Khoa IELTS
//
//  Created by ColWorx on 02/01/2019.
//  Copyright © 2019 ast. All rights reserved.
//

import Foundation

struct Sections {
    var image: String
    var title: String
    var items: [[String: AnyObject]]
    var expanded: Bool
    
    init(image: String, title: String, items: [[String:AnyObject]], expanded: Bool) {
        self.image = image
        self.title = title
        self.items = items
        self.expanded = expanded
    }
}
