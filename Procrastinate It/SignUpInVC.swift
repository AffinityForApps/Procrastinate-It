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

class SignUpInVC: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        //Autofilling my sign in data while building and testing
        usernameField.text = "steven@steven.com"
        passwordField.text = "asdf123"
        
    }

    //This will need to be revisted when authentication is performed through facebook and google
 
    @IBAction func signUpInTapped(_ sender: Any) {
        
        FIRAuth.auth()?.signIn(withEmail: usernameField.text!, password: passwordField.text!, completion: { (user, error) in
            print("We tried to sign in")
            
            //If user does not have an account create one
            
            if error != nil {
                print("Hey we have an error:\(error)")
                
                FIRAuth.auth()?.createUser(withEmail: self.usernameField.text!, password: self.passwordField.text!, completion: { (user, error) in
                    print("We tried to create a user")
                    
                    //After account is created, sign the user in
                    
                    if error != nil {
                        print("Hey we have an error:\(error)")
                    } else {
                        print("User created successfully")
                        
                        FIRDatabase.database().reference().child("users").child(user!.uid).child("email").setValue(user!.email!)
                        
                        
                        self.performSegue(withIdentifier: "signInSegue", sender: nil)
                    }
                })
                
                //If user does have an account, sign them in
                
            } else {
                print("We Signed In")
                self.performSegue(withIdentifier: "signInSegue", sender: nil)
            }
            
        })
        
    }

}
