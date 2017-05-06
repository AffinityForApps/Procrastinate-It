//
//  SignUpInVC.swift
//  Procrastinate It
//
//  Created by Steven Sherry on 2/25/17.
//  Copyright © 2017 Affinity for Apps. All rights reserved.
//  Testing

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FBSDKLoginKit
var didLogOut = false
var facebookLoginSuccess = false

class SignUpInVC: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var facebookLogin: UIButton!
    @IBOutlet weak var emailLogin: UIButton!
    @IBOutlet weak var emailSignInStackView: UIStackView!
    @IBOutlet weak var newUser: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Autofilling my sign in data while building and testing

        emailSignInStackView.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if (FIRAuth.auth()?.currentUser) != nil {
            if didLogOut == false {
                procrastinateIt()
            }
            
        }
        
        if (FBSDKAccessToken.current() != nil && facebookLoginSuccess) {
            procrastinateIt()
        }
        if didLogOut {
            logOut()
        }
        
    }
    
    @IBAction func facebookTapped(_ sender: Any) {
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, err) in
            if err != nil {
                print("FB Login failed", err as Any)
                return
            }
            
        }
     
        facebookFirebaseSignInDetails()
    }
    

    
    //This will need to be revisted when authentication is performed through facebook and google
 
    @IBAction func signUpInTapped(_ sender: Any) {
        
        FIRAuth.auth()?.signIn(withEmail: usernameField.text!.lowercased(), password: passwordField.text!, completion: { (user, error) in
            print("We tried to sign in")
            
            //Potential error codes and user prompts
            
            if error != nil {
                
                if let errCode = FIRAuthErrorCode(rawValue: error!._code){
                    switch errCode {
                        
                    case .errorCodeWrongPassword:
                        self.alertUserError(title: "Password Incorrect", message: "Please verify that your password is correct and try again")
                    
                    case .errorCodeInvalidEmail:
                        self.alertUserError(title: "Invalid email", message: "Please verify that your email is correct")
                    
                    case .errorCodeUserNotFound:
                        self.alertUserError(title: "No account found", message: "Please verify that your email is correct or create a new account to continue")
                        
                    default:
                        print("\(String(describing: error))")
                    }
                }
                
            //Else present them with the primary screen
                
            } else {
                print("We Signed In")
                self.emailSignInStackView.isHidden = true
                self.emailLogin.isHidden = false
                self.usernameField.text = ""
                self.passwordField.text = ""
                self.procrastinateIt()
            }
            
        })
        
    }
    
    //The following methods is needed to log into Firebase using Facebook
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
       
    func procrastinateIt(){
        self.performSegue(withIdentifier: "signInSegue", sender: nil)
    }
    
    func logOut(){
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func emailLoginTapped(_ sender: Any) {
        emailLogin.isHidden = true
        emailSignInStackView.isHidden = false
    }
    
    @IBAction func newUserTapped(_ sender: Any) {
        performSegue(withIdentifier: "newEmailUser", sender: nil)
        emailSignInStackView.isHidden = true
        emailLogin.isHidden = false
    }
    
    func alertUserError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
        
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    

}
