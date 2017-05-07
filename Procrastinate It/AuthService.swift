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
                    firebaseAuthStatusCode = errCode.rawValue
                    print(firebaseAuthStatusCode)
                    alert = AlertService.instance.alertUserError(withError: AlertEnum(rawValue: firebaseAuthStatusCode)!)
                } else {
                    firebaseAuthStatusCode = 0
                }
                completion(false)
            } else {
                print("We signed in with \(String(describing: user!.email))")
                completion(true)
            }
            
        })
    }
    
    func createNewUser(email: String, password: String, verifyPassword: String, completion: @escaping callback){
        if email.isEmpty || password.isEmpty || verifyPassword.isEmpty {
            alert = AlertService.instance.customAlert(title: "Form Incomplete", message: "Please fill in all fields to sign up for Procrastinate It")
            completion(false)
        } else if password != verifyPassword {
            alert = AlertService.instance.customAlert(title: "Passwords Do Not Match", message: "Please try again")
            completion(false)
        } else {
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                print("Attempting to create a user")
                if error != nil {
                    if let errCode = FIRAuthErrorCode(rawValue: error!._code){
                        firebaseAuthStatusCode = errCode.rawValue
                        print(firebaseAuthStatusCode)
                        alert = AlertService.instance.alertUserError(withError: AlertEnum(rawValue: firebaseAuthStatusCode)!)
                    } else {
                        firebaseAuthStatusCode = 0
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
    
    func facebookSignIn(viewController: UIViewController){
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: viewController) { (result, err) in
            if err != nil {
                print("FB Login failed", err as Any)
                return
            }
        }
        facebookFirebaseSignInDetails()
    }
    
    func facebookFirebaseSignInDetails(){
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else {return}
        
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, err) in
            if err != nil {
                print("something went wrong with our FB user:", err as Any)
            }
            print("successfully logged in with our user: ", user as Any)
            facebookLoginSuccess = true
            //Creates database entry for user
            FIRDatabase.database().reference().child("users").child(user!.uid).child("email").setValue(user!.email!)
            
        })
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
            if err != nil {
                print("failed to start graph request:", err as Any)
                return
            }
            print(result as Any)
        }
        
    }
    
    func logOut(){
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
}
