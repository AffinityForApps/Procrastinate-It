//
//  User.swift
//  Procrastinate It
//
//  Created by Steven Sherry on 2/25/17.
//  Copyright © 2017 Affinity for Apps. All rights reserved.
//

import Foundation
class User {
    private var _username: String
    private var _uid: String
    
    var username: String {
        get {
            return _username
        }
    }
    
    var uid: String {
        get {
            return _uid
        }
    }
    
    init(username: String, uid: String) {
        self._username = username
        self._uid = uid
    }    
    
}
