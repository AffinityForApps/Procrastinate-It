//
//  ProcrastinateVC.swift
//  Procrastinate It
//
//  Created by Steven Sherry on 2/27/17.
//  Copyright © 2017 Affinity for Apps. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ProcrastinateVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    //For date manipulation
    //Still need to initialize through PITask so that it can be synced from firebase...
    var currentDate = Date()
    let secondsInDay = 60*60*24
    let dateFormatter = DateFormatter()
    
    
    let ref = FIRDatabase.database().reference()
    let user = FIRAuth.auth()!.currentUser!.uid
    
    var tasks : [PITask] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
    
        self.ref.child("users/\(user)/tasks").observe(FIRDataEventType.childAdded, with: {(snapshot) in print(snapshot)
            
            let snapshotDictionary = snapshot.value as? [String:Any]
            
            //Initializing task with Firebase data
            
            let task = PITask(taskName: snapshotDictionary!["Task Name"] as! String, taskInfo: snapshotDictionary!["Task Info"] as! String, taskPriority: snapshotDictionary!["Task Priority"] as! Int, taskInterval: snapshotDictionary!["Task Interval"] as! Int, taskKey: snapshot.key, taskDate: self.dateFormatter.date(from: snapshotDictionary!["Task Date"] as! String)! as Date, lastIncrease: self.dateFormatter.date(from: snapshotDictionary!["Last Increase"] as! String)! as Date, isRecurring:snapshotDictionary!["Recurring"] as! Bool)
            
            self.tasks.append(task)
            
            /* 
            Date hack to increase taskPriority by taskInterval for each day passed..this may be
            exponential...
            date format should be done in the yyyy-MM-dd format. The default system format was having
            trouble converting from Date to String and back to Date again when being synced from Firebase
            */
            var index = 0
            for task in self.tasks{
                if task.lastIncrease != self.currentDate {
                    let days = (self.currentDate.timeIntervalSince(task.lastIncrease)/Double(self.secondsInDay)) - 1
                    if days > 1 {
                        task.taskPriority += task.taskInterval * Int(days)
                        if task.taskPriority >= 10{
                            task.taskPriority = 10
                        }
                        task.lastIncrease = self.currentDate
                        self.ref.child("users/\(self.user)/tasks/\(task.taskKey)/Last Increase").setValue(self.dateFormatter.string(from: task.lastIncrease))
                        self.ref.child("users/\(self.user)/tasks/\(task.taskKey)/Task Priority").setValue(task.taskPriority)
                    }
                    
                }
                index += 1
            }

            //sorts in descending order, contrary to what the comparison operator would have you believe
            self.tasks.sort(by: {$1.taskPriority < $0.taskPriority})
            self.tableView.reloadData()
        })
        
        /*
         Refreshes the data when a task has been changed. For some reason the object was able to refresh
         the integer variables being string interpolated, but not string variables so the object had to
         be deleted from the the array and re-appended.
        */
        
        
        self.ref.child("users/\(user)/tasks").observe(FIRDataEventType.childChanged, with: {(snapshot) in print(snapshot)
            
            var index = 0
            for task in self.tasks{
                if snapshot.key == task.taskKey{
                    self.tasks.remove(at: index)
                }
                index += 1
            }
            
            let snapshotDictionary = snapshot.value as? NSDictionary
            
            //Initializing task with Firebase data
            
            let task = PITask(taskName: snapshotDictionary!["Task Name"] as! String, taskInfo: snapshotDictionary!["Task Info"] as! String, taskPriority: snapshotDictionary!["Task Priority"] as! Int, taskInterval: snapshotDictionary!["Task Interval"] as! Int, taskKey: snapshot.key, taskDate: self.dateFormatter.date(from:snapshotDictionary!["Task Date"] as! String)!, lastIncrease: self.dateFormatter.date(from: snapshotDictionary!["Last Increase"] as! String)! as Date, isRecurring: snapshotDictionary!["Recurring"] as! Bool)
            
            self.tasks.append(task)
            
            index = 0
            for task in self.tasks{
                if task.lastIncrease != self.currentDate {
                    let days = self.currentDate.timeIntervalSince(task.lastIncrease)/Double(self.secondsInDay)
                    if days > 1 {
                        task.taskPriority += task.taskInterval * Int(days)
                        if task.taskPriority >= 10{
                            task.taskPriority = 10
                        }
                        task.lastIncrease = self.currentDate
                        self.ref.child("users/\(self.user)/tasks/\(task.taskKey)/Last Increase").setValue(self.dateFormatter.string(from: task.lastIncrease))
                        self.ref.child("users/\(self.user)/tasks/\(task.taskKey)/Task Priority").setValue(task.taskPriority)
                    }
                    
                }
                index += 1
            }
            
            //sorts in descending order, contrary to what the comparison operator would have you believe
            self.tasks.sort(by: {$1.taskPriority < $0.taskPriority})
            self.tableView.reloadData()
        })
        
        //Pops task from array when deleted
        
        self.ref.child("users/\(user)/tasks").observe(FIRDataEventType.childRemoved, with: {(snapshot) in print(snapshot)
            
            var index = 0
            for task in self.tasks{
                if snapshot.key == task.taskKey{
                    self.tasks.remove(at: index)
                }
                index += 1
            }
            
            //sorts in descending order, contrary to what the comparison operator would have you believe
            
            index = 0
            for task in self.tasks{
                if task.lastIncrease != self.currentDate {
                    let days = self.currentDate.timeIntervalSince(task.lastIncrease)/Double(self.secondsInDay)
                    if days > 1 {
                        task.taskPriority += task.taskInterval * Int(days)
                        if task.taskPriority >= 10{
                            task.taskPriority = 10
                        }
                        task.lastIncrease = self.currentDate
                        self.ref.child("users/\(self.user)/tasks/\(task.taskKey)/Last Increase").setValue(self.dateFormatter.string(from: task.lastIncrease))
                        self.ref.child("users/\(self.user)/tasks/\(task.taskKey)/Task Priority").setValue(task.taskPriority)
                    }
                    
                }
                index += 1
            }
            
            self.tasks.sort(by: {$1.taskPriority < $0.taskPriority})
            self.tableView.reloadData()
        })

        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tasks.count == 0 {
            return 1
        } else {
            return tasks.count
        }
    }
    
    //Defines the cells textual data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PICell", for: indexPath) as! PICell
        
        if tasks.count == 0 {
            
            cell.taskLabel?.text = "You currently have no tasks"
            cell.priorityLabel?.text = ""
            return cell
            
        } else {
            
            let task = tasks[indexPath.row]
            cell.taskLabel?.text = task.taskName
            cell.priorityLabel?.text = "\(task.taskPriority)"
            cell.detailsLabel?.text = task.taskInfo
            return cell
            
        }
    }
    
    //Provides the user permission to swipe left to select option to delete
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tasks.count == 0 {
            return false
        } else {
            return true
        }
    }
    
    //Allows the user to swipe left to select the option to delete
    //This will need to be revisted when the UI is overhauled
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            if task.isRecurring{
                self.ref.child("users/\(user)/tasks/\(task.taskKey)/Task Priority").setValue(0)
                self.tableView.reloadData()
            } else {
                self.ref.child("users/\(user)/tasks/\(task.taskKey)").removeValue()
                self.tableView.reloadData()
            }
        }
    }
    
    //Activates segue to EditTaskVC
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tasks.count > 0 {
            let task = tasks[indexPath.row]
            performSegue(withIdentifier: "editSegue", sender: task)
        }
    }
    
    //Provides the data to initialize an existing PITask to edit
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSegue"{
            let nextVC = segue.destination as! EditTaskVC
            nextVC.task = sender as! PITask
            if nextVC.isBeingDismissed {
                self.tableView.reloadData()
            }
            
        } else if segue.identifier == "addSegue" {
            let nextVC = segue.destination as! AddTaskVC
            if nextVC.isBeingDismissed {
                self.tableView.reloadData()
            }
        }
    }
    
}
