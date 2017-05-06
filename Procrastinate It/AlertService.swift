//
//  AlertService.swift
//  Procrastinate It
//
//  Created by Steven Sherry on 5/6/17.
//  Copyright © 2017 Affinity for Apps. All rights reserved.
//

import Foundation
import UIKit

class AlertService {
    
    static let instance = AlertService()
    var alertController = UIAlertController(title: "Uknown Error", message: "Please check your username and password and try again", preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
    
    
    func alertUserError(withError error: AlertEnum) -> UIAlertController {
        
        switch error {
        case .invalidEmail:
            alertController = UIAlertController(title: "Invalid Email", message: "Please verify that your email is correct", preferredStyle: .alert)
            break
            
        case .noAccount:
            alertController = UIAlertController(title: "No account found", message: "Please verify you have used the correct email or create a new account to continue", preferredStyle: .alert)
            break
        
        case .wrongPassword:
            alertController = UIAlertController(title: "Password Incorrect", message: "Please verify that your password is correct and try again", preferredStyle: .alert)
            break
        
        case .userAlreadyExists:
            alertController = UIAlertController(title: "Email In Use", message: "This email is already registered", preferredStyle: .alert)
            break
            
        case .weakPassword:
            alertController = UIAlertController(title: "Password too weak", message: "Password must contain at least 6 characters", preferredStyle: .alert)
            break
        
        default:
            print("Unknown error")
            break
        }
        
        alertController.addAction(defaultAction)
        return alertController
    }
    
    func customAlert(title: String, message: String) -> UIAlertController {
        alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(defaultAction)
        return alertController
    }
    
}
