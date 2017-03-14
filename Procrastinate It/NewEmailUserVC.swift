//
//  NewEmailUserVC.swift
//  Procrastinate It
//
//  Created by Steven Sherry on 3/12/17.
//  Copyright © 2017 Affinity for Apps. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


class NewEmailUserVC: UIViewController {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if didLogOut == true {
            self.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func signUpTapped(_ sender: Any) {
        informationalAlert()
    }

    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func informationalAlert(){
        if ((emailTF.text?.isEmpty)! || (passwordTF.text?.isEmpty)! || (confirmPasswordTF.text?.isEmpty)!){
            alertUserError(title: "Form incomplete", message: "Please fill in all fields to sign up for Procrastinate It")
        }
        if passwordTF.text != confirmPasswordTF.text {
            alertUserError(title: "Passwords do not match",message: "Please try again")
        }
        
        createUser()
        
    }
    
    func createUser(){
        FIRAuth.auth()?.createUser(withEmail: self.emailTF.text!.lowercased(), password: self.passwordTF.text!, completion: { (user, error) in
            print("We tried to create a user")
            
            //Error handling
            
            if error != nil {
                if let errCode = FIRAuthErrorCode(rawValue: error!._code){
                    switch errCode {
                    case .errorCodeEmailAlreadyInUse:
                        if let email = self.emailTF.text?.lowercased() {
                            self.alertUserError(title: "Email in use", message: "\(email) is already registered with Procrastinate it")
                        }
                        
                    case .errorCodeWeakPassword:
                        self.alertUserError(title: "Password too weak", message: "Password must contain at least 6 characters")
                    
                    case .errorCodeInvalidEmail:
                        self.alertUserError(title: "Invalid email", message: "Please verify that your email is correct")
                    
                    default:
                        print("\(error)")
                    }
                }

            } else {
                print("User created successfully")
                //Creates database entry for user
                FIRDatabase.database().reference().child("users").child(user!.uid).child("email").setValue(user!.email!)
                self.performSegue(withIdentifier: "signUpSegue", sender: nil)
            }
        })
        
    }
    
    //Alert template for error handling and communication to user
    func alertUserError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
        
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }

}
