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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Sets the UI's visual data whether a new task or existing task
        taskTitleField.text = task.taskName
        taskDetailsField.text = task.taskInfo
        priorityLabel.text = "\(task.taskPriority)"
        intervalLabel.text = "\(task.taskInterval)"
        prioritySlider.value = Float(task.taskPriority)
        intervalSlider.value = Float(task.taskInterval)
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
        DataService.instance.uploadTask(user: user, ref: ref, taskKey: self.task.taskKey, firTask: DataService.instance.prepareForFirebaseUpload(user: user, ref: ref, task: PITask(taskName: self.taskTitleField.text!, taskInfo: self.taskDetailsField.text!, taskPriority: self.task.taskPriority, taskInterval: self.task.taskInterval, taskKey: self.task.taskKey, taskDate: self.task.taskDate, lastIncrease: self.task.lastIncrease, isRecurring: self.task.isRecurring)))
        
        let selectedDate = Date()
        let selectedDate2 = selectedDate.addingTimeInterval(60)
        let delegate = UIApplication.shared.delegate as? AppDelegate
        delegate?.scheduleNotification(at: selectedDate2)
        
        _ = navigationController?.popToRootViewController(animated: true)
    }
}
