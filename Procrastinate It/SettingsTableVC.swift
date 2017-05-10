//
//  SettingsTableVC.swift
//  Procrastinate It
//
//  Created by Steven Sherry on 5/9/17.
//  Copyright © 2017 Affinity for Apps. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SettingsTableVC: UITableViewController {
    
    @IBOutlet weak var convertToFacebookButton: UIButton!
    @IBOutlet weak var convertToEmailButton: UIButton!
    @IBOutlet weak var emailConversionForm: UIStackView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var connectAccountButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    let user = FIRAuth.auth()!.currentUser!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailConversionForm.isHidden = true

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    @IBAction func convertToFacebookTapped(_ sender: Any) {
        AuthService.instance.convertAnonToFacebook(user: user, viewController: self) { (success) in success ?
            self.dismiss(animated: true, completion: nil) : self.present(alert, animated: true, completion:  nil) }
        }
    
    @IBAction func convertToEmailTapped(_ sender: Any) {
        convertToEmailButton.isHidden = true
        convertToFacebookButton.isHidden = true
        emailConversionForm.isHidden = false
    }

    @IBAction func connectAccountTapped(_ sender: Any) {
        AuthService.instance.convertAnonToEmail(user: user, email: emailTF.text!, password: passwordTF.text!, verifyPassword: confirmPasswordTF.text!) { (success) in success ? self.dismiss(animated: true, completion: nil) :
            self.present(alert, animated: true, completion:  nil) }
    }
 

}
