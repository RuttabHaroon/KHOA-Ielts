//
//  Questions.swift
//  Khoa IELTS
//
//  Created by Office on 4/26/19.
//  Copyright © 2019 ast. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Questions {
    var maintitle : String!
    var image : String!
    var section : [Sections]
    
    
    init (maintitle: String, image: String, section: [Sections]) {
        self.maintitle = maintitle
        self.image = image
        self.section = section
    }
}
