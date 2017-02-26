//
//  AddTaskVC.swift
//  Procrastinate It
//
//  Created by Steven Sherry on 2/23/17.
//  Copyright © 2017 Affinity for Apps. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class AddTaskVC: UIViewController {

    @IBOutlet weak var taskTitleField: UITextField!
    
    @IBOutlet weak var taskDetailsField: UITextView!
    
    @IBOutlet weak var priorityLabel: UILabel!
    
    @IBOutlet weak var intervalLabel: UILabel!
    
    let ref = FIRDatabase.database().reference()
    let user = FIRAuth.auth()!.currentUser!.uid

    
    var priority = 0
    var interval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.taskTitleField.text = ""
        self.taskDetailsField.text = ""
        self.priorityLabel.text = "\(priority)"
        self.intervalLabel.text = "\(interval)"
        
    }

    @IBAction func priorityIncreaseTapped(_ sender: Any) {
        if priority >= 10 {
            priority = 10
        } else {
            priority += 1
        }
        self.priorityLabel.text = "\(priority)"
    }
   
    @IBAction func priorityDecreaseTapped(_ sender: Any) {
        if priority <= 0{
            priority = 0
        } else {
            priority -= 1
        }
        self.priorityLabel.text = "\(priority)"
    }
    
    @IBAction func intervalIncreaseTapped(_ sender: Any) {
        if interval >= 10{
            interval = 10
        } else {
            interval += 1
        }
        self.intervalLabel.text = "\(interval)"
    }
    

    @IBAction func intervalDecreaseTapped(_ sender: Any) {
        if interval <= 0{
            interval = 0
        } else {
            interval -= 1
        }
        self.intervalLabel.text = "\(interval)"
    }
 
    @IBAction func addTaskTapped(_ sender: Any) {
        
        let newTask = PITask(taskName: taskTitleField.text!, taskInfo: taskDetailsField.text!, taskPriority: priority, taskInterval: interval, taskKey: "")
        
        let task = ["Task Name":newTask.taskName,"Task Info":newTask.taskInfo,"Task Priority":newTask.taskPriority,"Task Interval":newTask.taskInterval] as [String : Any]
        
        self.ref.child("users/\(user)/tasks").childByAutoId().setValue(task)
        
        self.navigationController?.popToRootViewController(animated: true)
    }

}
