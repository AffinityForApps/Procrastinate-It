//
//  EditTaskVC.swift
//  Procrastinate It
//
//  Created by Steven Sherry on 2/26/17.
//  Copyright © 2017 Affinity for Apps. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class EditTaskVC: UIViewController {
    
    var task = PITask(taskName: "", taskInfo: "", taskPriority: 0, taskInterval: 0, taskKey: "")
    
    @IBOutlet weak var taskTitleField: UITextField!
    @IBOutlet weak var taskDetailsField: UITextView!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var intervalLabel: UILabel!
    
    let ref = FIRDatabase.database().reference()
    let user = FIRAuth.auth()!.currentUser!.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()

        taskTitleField.text = task.taskName
        taskDetailsField.text = task.taskInfo
        priorityLabel.text = "\(task.taskPriority)"
        intervalLabel.text = "\(task.taskInterval)"
        
    }

    @IBAction func priorityIncreaseTapped(_ sender: Any) {
        if task.taskPriority >= 10 {
            task.taskPriority = 10
        } else {
            task.taskPriority += 1
        }
        self.priorityLabel.text = "\(task.taskPriority)"
    }
    
    @IBAction func priorityDecreaseTapped(_ sender: Any) {
        if task.taskPriority <= 0 {
            task.taskPriority = 0
        } else {
            task.taskPriority -= 1
        }
        self.priorityLabel.text = "\(task.taskPriority)"
    }

    @IBAction func intervalIncreaseTapped(_ sender: Any) {
        if task.taskInterval >= 10 {
            task.taskInterval = 10
        } else {
            task.taskInterval += 1
        }
        self.intervalLabel.text = "\(task.taskInterval)"
    }

    
    @IBAction func intervalDecreaseTapped(_ sender: Any) {
        if task.taskInterval <= 0 {
            task.taskInterval = 0
        } else {
            task.taskInterval -= 1
        }
        self.intervalLabel.text = "\(task.taskInterval)"
    }
    
    
    @IBAction func saveTapped(_ sender: Any) {
        
        let editedTask = PITask(taskName: self.taskTitleField.text!, taskInfo: self.taskDetailsField.text!, taskPriority: self.task.taskPriority, taskInterval: self.task.taskInterval, taskKey: self.task.taskKey)
        
        let task = ["Task Name":editedTask.taskName,"Task Info":editedTask.taskInfo,"Task Priority":editedTask.taskPriority,"Task Interval":editedTask.taskInterval] as [String : Any]
        
        self.ref.child("users/\(user)/tasks/\(editedTask.taskKey)").updateChildValues(task)
        
        self.navigationController?.popToRootViewController(animated: true)
        
    }

}
