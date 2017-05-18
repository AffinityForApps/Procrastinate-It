//
//  EditTask2VC.swift
//  Procrastinate It
//
//  Created by Steven Sherry on 5/12/17.
//  Copyright © 2017 Affinity for Apps. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class EditTask2VC: UIViewController {
    
    var task = PITask(taskName: "", taskInfo: "", taskPriority: 0, taskInterval: 0,
                      taskKey: "", taskDate: Date(), lastIncrease: Date(), isRecurring: false)
    
    @IBOutlet weak var taskTitleField: UITextField!
    @IBOutlet weak var taskDetailsField: UITextView!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var deadlineField: UITextField!
    @IBOutlet weak var deadlineButton: UIButton!
    
    @IBOutlet weak var prioritySlider: UISlider!
    @IBOutlet weak var recurringTaskSwitch: UISwitch!
    
    var datePicker: AADatePicker!
    
    let ref = FIRDatabase.database().reference()
    let user = FIRAuth.auth()!.currentUser!.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker = AADatePicker(viewController: self, label: deadlineLabel, textField: deadlineField, task: task)
        
        deadlineField.isHidden = true
        
        if task.taskName == "" {
            deadlineLabel.text = "Deadline:"
        }
        
        //Sets the UI's visual data whether a new task or existing task
        taskTitleField.text = task.taskName
        taskDetailsField.text = task.taskInfo
        priorityLabel.text = "\(Int(task.taskPriority))"
        prioritySlider.value = Float(task.taskPriority)
        recurringTaskSwitch.isOn = task.isRecurring
        
        //Remove previous VC Navbar title from back button
        if let navigationBar = self.navigationController?.navigationBar {
            //Set back button color to compliment the app color scheme
            navigationBar.tintColor = UIColor(red: 0.29, green: 0.65, blue: 0.65, alpha: 1.0)
            if let topItem = navigationBar.topItem {
                topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            }
        }
    }

    @IBAction func prioritySliderMoved(_ sender: Any) {
        task.taskPriority = Double(Int(prioritySlider.value))
        self.priorityLabel.text = "\(Int(prioritySlider.value))"
    }
    
    @IBAction func recurringTaskSwitchTapped(_ sender: Bool) {
        if recurringTaskSwitch.isOn {
            task.isRecurring = true
        } else {
            task.isRecurring = false
        }
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        let task = self.initTask()
        DataService.instance.uploadTask(user: user, ref: ref, taskKey: self.task.taskKey,
                                        firTask: DataService.instance.prepareForFirebaseUpload(user: user, ref: ref, task: task))
        
        PanicMonster.instance.scheduleNotification(forTask: task)
        
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func deadlineButtonTapped(_ sender: Any) {
        deadlineField.becomeFirstResponder()
    }
    
    private func initTask() -> PITask {
        return PITask(taskName: taskTitleField.text!, taskInfo: taskDetailsField.text!,
                      taskPriority: task.taskPriority, taskInterval: task.taskInterval,
                      taskKey: task.taskKey, taskDate: task.taskDate,
                      lastIncrease: task.lastIncrease, isRecurring: task.isRecurring)
    }
}


