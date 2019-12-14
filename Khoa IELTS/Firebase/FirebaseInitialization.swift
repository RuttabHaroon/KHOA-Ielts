//
//  FirebaseInitialization.swift
//  Khoa IELTS
//
//  Created by Office on 4/26/19.
//  Copyright © 2019 ast. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseInitialization: NSObject {
    
    class func databaseReference() -> DatabaseReference {
        return Database.database().reference()
    }
}
