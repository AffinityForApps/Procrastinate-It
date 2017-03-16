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
    
    var task = PITask(taskName: "", taskInfo: "", taskPriority: 0, taskInterval: 0, taskKey: "", taskDate: Date(), lastIncrease: Date(), isRecurring: false)
    
    @IBOutlet weak var taskTitleField: UITextField!
    @IBOutlet weak var taskDetailsField: UITextView!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var intervalLabel: UILabel!
    
    @IBOutlet weak var prioritySlider: UISlider!
    @IBOutlet weak var intervalSlider: UISlider!
    
    @IBOutlet weak var recurringTaskSwitch: UISwitch!
    
    let ref = FIRDatabase.database().reference()
    let user = FIRAuth.auth()!.currentUser!.uid
    let dateFormatter = DateFormatter()
    var formattedDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        taskTitleField.text = task.taskName
        taskDetailsField.text = task.taskInfo
        priorityLabel.text = "\(task.taskPriority)"
        intervalLabel.text = "\(task.taskInterval)"
        prioritySlider.value = Float(task.taskPriority)
        intervalSlider.value = Float(task.taskInterval)
        recurringTaskSwitch.isOn = task.isRecurring
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formattedDate = dateFormatter.string(from: Date())
        
        //Remove previous VC Navbar title from back button
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.tintColor = UIColor(red: 0.29, green: 0.65, blue: 0.65, alpha: 1.0)
            if let topItem = navigationBar.topItem {
                topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            }
        }
        
    }

    
    @IBAction func prioritySliderMoved(_ sender: Any) {
        task.taskPriority = Int(prioritySlider.value)
        self.priorityLabel.text = "\(task.taskPriority)"
        
    }
    
    @IBAction func intervalSliderMoved(_ sender: Any) {
        task.taskInterval = Int(intervalSlider.value)
        self.intervalLabel.text = "\(task.taskInterval)"
    }

    @IBAction func recurringTaskSwitchTapped(_ sender: Bool) {
        if recurringTaskSwitch.isOn {
            task.isRecurring = true
        } else {
            task.isRecurring = false
        }
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        
        let editedTask = PITask(taskName: self.taskTitleField.text!, taskInfo: self.taskDetailsField.text!, taskPriority: self.task.taskPriority, taskInterval: self.task.taskInterval, taskKey: self.task.taskKey, taskDate: self.task.taskDate, lastIncrease: Date(), isRecurring: self.task.isRecurring)
        
        //Task date is not included in the task edit so the date is not overwritten
        
        let task = ["Task Name":editedTask.taskName,"Task Info":editedTask.taskInfo,"Task Priority":editedTask.taskPriority,"Task Interval":editedTask.taskInterval, "Last Increase":formattedDate,"Recurring":editedTask.isRecurring] as [String : Any]
        
        self.ref.child("users/\(user)/tasks/\(editedTask.taskKey)").updateChildValues(task)
        
        _ = navigationController?.popToRootViewController(animated: true)
        
    }

}
