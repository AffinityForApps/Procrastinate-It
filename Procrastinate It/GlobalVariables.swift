//
//  Constants.swift
//  Procrastinate It
//
//  Created by Steven Sherry on 5/6/17.
//  Copyright © 2017 Affinity for Apps. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias callback = (_ success: Bool) -> ()
var didLogOut = false
var facebookLoginSuccess = false
var firebaseAuthStatusCode: Int = 0
var alert = AlertService.instance.customAlert(title: "Default", message: "This better not show up")
