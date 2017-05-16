//
//  AlertService.swift
//  Procrastinate It
//
//  Created by Steven Sherry on 5/6/17.
//  Copyright © 2017 Affinity for Apps. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class AlertService {
    
    static let instance = AlertService()
    var alertController = UIAlertController(title: "Unknown Error", message: "Please check your username and password and try again", preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
    
    private init(){}
    
    //May change this to just work with the standard Firebase error codes directly
    //instead of converting them to work with AlertEnum
    
    func alertUserError(withError firError: FIRAuthErrorCode) -> UIAlertController {
        switch firError {
            
        // User authentication errors
        case .errorCodeInvalidEmail:
            alertController = UIAlertController(title: "Invalid Email", message: "Please verify that your email is correct", preferredStyle: .alert)
            break
            
        case .errorCodeWeakPassword:
            alertController = UIAlertController(title: "Password Too Weak", message: "Password must contain at least 6 characters", preferredStyle: .alert)
            break
            
        case .errorCodeWrongPassword:
            alertController = UIAlertController(title: "Incorrect Password", message: "Please try again", preferredStyle: .alert)
            break
            
        case .errorCodeUserNotFound:
            alertController = UIAlertController(title: "No Account Found", message: "Please verify you have used the correct email or create a new account to continue", preferredStyle: .alert)
            break
            
        case .errorCodeProviderAlreadyLinked:
            alertController = UIAlertController(title: "Authentication Provider Already Linked", message: "Your account is already linked using this provider", preferredStyle: .alert)
            break
        
        case .errorCodeEmailAlreadyInUse:
            alertController = UIAlertController(title: "Account already exists", message: "This email is already registered", preferredStyle: .alert)
            break
            
        // Developer authentication errors
        case .errorCodeInternalError:
            alertController = UIAlertController(title: "Internal Error", message: "Please close the app and try again", preferredStyle: .alert)
            break
        
        case .errorCodeInvalidAPIKey:
            alertController = UIAlertController(title: "Invalid API Key", message: "This app has been configured incorrectly", preferredStyle: .alert)
            break
            
        case .errorCodeUserDisabled:
            alertController = UIAlertController(title: "Account Disabled", message: "This account is no longer authorized to use this service", preferredStyle: .alert)
            break
            
        case .errorCodeUserMismatch:
            alertController = UIAlertController(title: "Authentication Failed", message: "Please close the app and try again", preferredStyle: .alert)
            break
            
        // System and network Errors

        case .errorCodeNetworkError:
            alertController = UIAlertController(title: "Network Error", message: "Please ensure your device is connected to wifi or a data network and try again", preferredStyle: .alert)
            break
            
        case .errorCodeKeychainError:
            alertController = UIAlertController(title: "Unable to Sign Out", message: "Unable to access user keychain", preferredStyle: .alert)
            break
            
        case .errorCodeNoSuchProvider:
            alertController = UIAlertController(title: "Provider Not Linked to Account", message: "The social media account you are attempting to unlink is not connected to this account", preferredStyle: .alert)
            break
            
        case .errorCodeTooManyRequests:
            alertController = UIAlertController(title: "Too Many Requests", message: "An abnormal number of requests have been made. This account has been temporarily blocked", preferredStyle: .alert)
            break
            
        case .errorCodeInvalidUserToken:
            alertController = UIAlertController(title: "Authentication Error", message: "Please sign in again", preferredStyle: .alert)
            break
            
        case .errorCodeUserTokenExpired:
            alertController = UIAlertController(title: "Login Expired", message: "Please sign in again", preferredStyle: .alert)
            break
            
        case .errorCodeInvalidCredential:
            alertController = UIAlertController(title: "Authentication Error", message: "Please sign in again", preferredStyle: .alert)
            break
            
        case .errorCodeInvalidCustomToken:
            alertController = UIAlertController(title: "Invalid Custom Token", message: "Please contact the app owner", preferredStyle: .alert)
            break
            
        case .errorCodeCustomTokenMismatch:
            alertController = UIAlertController(title: "Invalid Custom Token", message: "Please contact the app owner", preferredStyle: .alert)
            break
            
        case .errorCodeOperationNotAllowed:
            alertController = UIAlertController(title: "Authentication Method Not Allowed", message: "The developer has disabled this method of authentication. Please choose another authentication option", preferredStyle: .alert)
            break
            
        case .errorCodeRequiresRecentLogin:
            alertController = UIAlertController(title: "Login Expired", message: "Please sign in again", preferredStyle: .alert)
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
