//
//  Constants.swift
//  Procrastinate It
//
//  Created by Steven Sherry on 5/6/17.
//  Copyright © 2017 Affinity for Apps. All rights reserved.
//

import Foundation

typealias callback = (_ success: Bool) -> ()
var didLogOut = false
var facebookLoginSuccess = false
//These are global so they can be created in the AuthService class and presented in another.
var alert = AlertService.instance.customAlert(title: "Default", message: "This better not show up")

