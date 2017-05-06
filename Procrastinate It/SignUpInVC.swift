//
//  SignUpInVC.swift
//  Procrastinate It
//
//  Created by Steven Sherry on 2/25/17.
//  Copyright © 2017 Affinity for Apps. All rights reserved.
//  

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FBSDKLoginKit


class SignUpInVC: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var facebookLogin: UIButton!
    @IBOutlet weak var emailLogin: UIButton!
    @IBOutlet weak var emailSignInStackView: UIStackView!
    @IBOutlet weak var newUser: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        AuthService.instance.facebookSignIn(viewController: self)
    }
 
    @IBAction func signUpInTapped(_ sender: Any) {
        
        AuthService.instance.existingEmailUser(email: usernameField.text!.lowercased(), password: passwordField.text!) { (success) in
            if !success {
                self.present(alert, animated: true, completion: nil)
            } else {
                self.emailSignInStackView.isHidden = true
                self.emailLogin.isHidden = false
                self.usernameField.text = ""
                self.passwordField.text = ""
                self.procrastinateIt()
            }
        }
    }
    
    
    @IBAction func emailLoginTapped(_ sender: Any) {
        emailLogin.isHidden = true
        emailSignInStackView.isHidden = false
    }
    
    @IBAction func newUserTapped(_ sender: Any) {
        didLogOut = false
        performSegue(withIdentifier: "newEmailUser", sender: nil)
        emailSignInStackView.isHidden = true
        emailLogin.isHidden = false
    }
    
    func procrastinateIt(){
        self.performSegue(withIdentifier: "signInSegue", sender: nil)
    }
    
    func logOut(){
        AuthService.instance.logOut()
    }

}
