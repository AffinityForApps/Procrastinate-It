//
//  AlertEnum.swift
//  Procrastinate It
//
//  Created by Steven Sherry on 5/6/17.
//  Copyright © 2017 Affinity for Apps. All rights reserved.
//

import Foundation
import FirebaseAuth

enum AlertEnum: Int {
    case wrongPassword = 17009
    case invalidEmail = 17008
    case noAccount = 17011
    case userAlreadyExists = 17007
    case weakPassword = 17026
    case unknownError = 0
}
