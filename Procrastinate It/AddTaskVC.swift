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
    
    @IBOutlet weak var prioritySlider: UISlider!
    
    @IBOutlet weak var intervalSlider: UISlider!
    
    @IBOutlet weak var recurringTaskSwitch: UISwitch!
    
    let ref = FIRDatabase.database().reference()
    let user = FIRAuth.auth()!.currentUser!.uid
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    var formattedDate = ""
    var priority = 0
    var interval = 0
    var isRecurring = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formattedDate = dateFormatter.string(from: currentDate)
        
        taskTitleField.text = ""
        taskDetailsField.text = ""
        priorityLabel.text = "\(priority)"
        intervalLabel.text = "\(interval)"
        prioritySlider.value = 0
        intervalSlider.value = 0
        recurringTaskSwitch.isOn = false
        
        //Remove previous VC Navbar title from back button
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    }
    
    @IBAction func prioritySliderMoved(_ sender: Any) {
        priority = Int(prioritySlider.value)
        self.priorityLabel.text = "\(priority)"
    }
    
    @IBAction func intervalSliderMoved(_ sender: Any) {
        interval = Int(intervalSlider.value)
        self.intervalLabel.text = "\(interval)"
    }
    
    
    @IBAction func recurringTaskSwitchTapped(_ sender: Any) {
        if recurringTaskSwitch.isOn {
            isRecurring = true
        } else {
            isRecurring = false
        }
    }

 
    @IBAction func addTaskTapped(_ sender: Any) {
        
        let newTask = PITask(taskName: taskTitleField.text!, taskInfo: taskDetailsField.text!, taskPriority: priority, taskInterval: interval, taskKey: "", taskDate: currentDate, lastIncrease: currentDate, isRecurring: isRecurring)
        
        let task = ["Task Name":newTask.taskName,"Task Info":newTask.taskInfo,"Task Priority":newTask.taskPriority,"Task Interval":newTask.taskInterval, "Task Date": formattedDate, "Last Increase":formattedDate,"Recurring": newTask.isRecurring] as NSDictionary
        
        self.ref.child("users/\(user)/tasks").childByAutoId().setValue(task)
        
        _ = navigationController?.popToRootViewController(animated: true)
    }

}
