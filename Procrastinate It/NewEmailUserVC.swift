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
    
    //This dismisses the view controller in the event that a new user signs up and then logs out
    //Without utilizing viewDidAppear, the logout action in ProcrastinateVC would bring th user 
    //back to this view controller.
    override func viewDidAppear(_ animated: Bool) {
        if didLogOut == true {
            self.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func signUpTapped(_ sender: Any) {
        newUserSignUp()
    }

    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func newUserSignUp(){
        AuthService.instance.createNewUser(email: emailTF.text!.lowercased(), password: self.passwordTF.text!,
                                           verifyPassword: self.confirmPasswordTF.text!) { (success) in
            if !success {
                self.present(alert, animated: true, completion: nil)
            } else {
                self.performSegue(withIdentifier: "signUpSegue", sender: nil)
            }
        }
        
    }

}
