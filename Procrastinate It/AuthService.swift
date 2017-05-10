//
//  AuthService.swift
//  Procrastinate It
//
//  Created by Steven Sherry on 5/6/17.
//  Copyright © 2017 Affinity for Apps. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FBSDKLoginKit

class AuthService {
    
    static let instance = AuthService()
    
    func existingEmailUser(email: String, password: String, completion: @escaping callback){
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            print("Attempting sign in")
            if error != nil {
                if let errCode = FIRAuthErrorCode(rawValue: error!._code){
                    alert = AlertService.instance.alertUserError(withError: errCode)
                    print(errCode)
                }
                completion(false)
            } else {
                print("We signed in with \(String(describing: user!.email))")
                completion(true)
            }
            
        })
    }
    
    func createNewUser(email: String, password: String, verifyPassword: String, completion: @escaping callback){
        if !emailFormCompleteAndCorrect(email: email, password: password, verifyPassword: verifyPassword) {
            completion(false)
        } else {
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                print("Attempting to create a user")
                if error != nil {
                    if let errCode = FIRAuthErrorCode(rawValue: error!._code){
                        alert = AlertService.instance.alertUserError(withError: errCode)
                        print(errCode)
                        
                    }
                    completion(false)
                } else {
                    print("We created a new user")
                    FIRDatabase.database().reference().child("users").child(user!.uid).child("email").setValue(user!.email!)
                    completion(true)
                }
            })
        }
        
    }
    
    func facebookSignIn(viewController: UIViewController, completion: @escaping callback){
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: viewController) { (result, error) in
            if error != nil {
                if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                    alert = AlertService.instance.alertUserError(withError: errCode)
                    print(errCode)
                }
            }
            completion(false)
        }
        facebookFirebaseSignInDetails { (success) in success ? completion(true) : completion(false) }
    }
    

    
    func anonymousSignIn(completion: @escaping callback) {
        FIRAuth.auth()?.signInAnonymously(completion: { (user, error) in
            print("Attempting to create an anonymous user")
            if error != nil {
                print("There is an issue with anonymous login")
                alert = AlertService.instance.customAlert(title: "Unable To Continue", message: "There is an issue with our anonymous login. Please try again.")
                completion(false)
            }
            print("sucessfully logging with anonymoust user: ", user as Any)
            FIRDatabase.database().reference().child("users").child(user!.uid)
            completion(true)
        })
    }
    
    func convertAnonToFacebook(user: FIRUser, viewController: UIViewController, completion: @escaping callback) {
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: viewController) { (result, error) in
            if error != nil {
                if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                    alert = AlertService.instance.alertUserError(withError: errCode)
                    print(errCode)
                }
            }
            completion(false)
        }
        if user.isAnonymous {
            let accessToken = FBSDKAccessToken.current()
            guard let accessTokenString = accessToken?.tokenString else {return}
            let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
            user.link(with: credentials, completion: { (user, error) in
                if error != nil {
                    alert = AlertService.instance.customAlert(title: "Error Connecting Account", message: "There has been an error connecting your account to Facebook. Please try again")
                    completion(false)
                } else {
                    self.facebookGraphRequest(completion: { (success) in
                        if success {
                            alert = AlertService.instance.customAlert(title: "Success", message: "")
                            FIRDatabase.database().reference().child("users").child(user!.uid).child("email").setValue(user!.email!)
                            print("Anonymous user account successfully converted")
                            completion(true)
                        } else {
                            print("Epic fail")
                            completion(false)
                        }
                    })
                    
                }
            })
        } else {
            print("User is not anonymous")
        }
    }
    
    func convertAnonToEmail(user: FIRUser, email: String, password: String, verifyPassword: String, completion: @escaping callback) {
        if user.isAnonymous {
            if !emailFormCompleteAndCorrect(email: email, password: password, verifyPassword: verifyPassword) {
                completion(false)
            } else {
                let credential = FIREmailPasswordAuthProvider.credential(withEmail: email, password: password)
                user.link(with: credential, completion: { (user, error) in
                    if error != nil {
                        if let errCode = FIRAuthErrorCode(rawValue: error!._code){
                            alert = AlertService.instance.alertUserError(withError: errCode)
                            print(errCode)
                            completion(false)
                        }
                    } else {
                        alert = AlertService.instance.customAlert(title: "Success!", message: "")
                        FIRDatabase.database().reference().child("users").child(user!.uid).child("email").setValue(user!.email!)
                        print("Suecessfully converted anonymous user")
                        completion(true)
                    }
                })
            }
        } else {
            print("User is not anonymous")
            alert = AlertService.instance.customAlert(title: "Not an Anonymous User", message: "This email is already asssociated with an account on Procrastinate It")
            completion(false)
        }
    }
    

    
    func logOut(){
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    // Private methods
    private func facebookGraphRequest(completion: @escaping callback) {
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
            if err != nil {
                alert = AlertService.instance.customAlert(title: "Error", message: "Please try again later")
                print("failed to start graph request:", err as Any)
                completion(false)
            }
            completion(true)
        }
    }
    
    private func emailFormCompleteAndCorrect(email: String, password: String, verifyPassword: String) -> Bool {
        if email.isEmpty || password.isEmpty || verifyPassword.isEmpty {
            alert = AlertService.instance.customAlert(title: "Form Incomplete", message: "Please fill in all fields to sign up for Procrastinate It")
            return false
        } else if password != verifyPassword {
            alert = AlertService.instance.customAlert(title: "Passwords Do Not Match", message: "Please try again")
            return false
        } else {
            return true
        }
    }
    
    private func facebookFirebaseSignInDetails(completion: @escaping callback){
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else {return}
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                    alert = AlertService.instance.alertUserError(withError: errCode)
                    print(errCode)
                }
                completion(false)
            }
            print("successfully logged in with our user: ", user as Any)
            facebookLoginSuccess = true
            //Creates database entry for user
            FIRDatabase.database().reference().child("users").child(user!.uid).child("email").setValue(user!.email!)
            completion(true)
        })
        self.facebookGraphRequest{ (success) in success ? completion(true) : completion(false) }
    }
    
}
