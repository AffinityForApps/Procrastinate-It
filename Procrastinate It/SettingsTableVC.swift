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
//    @IBOutlet weak var connectAccountSection: UITableViewSection!
    
    let user = FIRAuth.auth()!.currentUser!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailConversionForm.isHidden = true
        if let navigationBar = self.navigationController?.navigationBar {
            //Set back button color to compliment the app color scheme
            navigationBar.tintColor = UIColor(red: 0.29, green: 0.65, blue: 0.65, alpha: 1.0)
            if let topItem = navigationBar.topItem {
                topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            }
        }
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
        _ = navigationController?.popToRootViewController(animated: true)
    }
 
    @IBAction func cancelTapped(_ sender: Any) {
        emailConversionForm.isHidden = true
        convertToEmailButton.isHidden = false
        convertToFacebookButton.isHidden = false
    }

}
