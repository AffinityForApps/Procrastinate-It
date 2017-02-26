//
//  ProcrastinateTVC.swift
//  Procrastinate It
//
//  Created by Steven Sherry on 2/25/17.
//  Copyright © 2017 Affinity for Apps. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ProcrastinateTVC: UITableViewController {
    
    let ref = FIRDatabase.database().reference()
    let user = FIRAuth.auth()!.currentUser!.uid
    
    var tasks : [PITask] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Appends array when new task is added
        
        self.ref.child("users/\(user)/tasks").observe(FIRDataEventType.childAdded, with: {(snapshot) in print(snapshot)
            
            let snapshotDictionary = snapshot.value as? NSDictionary
            
            //Initializing task with Firebase data
            
            let task = PITask(taskName: snapshotDictionary!["Task Name"] as! String, taskInfo: snapshotDictionary!["Task Info"] as! String, taskPriority: snapshotDictionary!["Task Priority"] as! Int, taskInterval: snapshotDictionary!["Task Interval"] as! Int, taskKey: snapshot.key)
            
            self.tasks.append(task)
            //sorts in descending order, contrary to what the comparison operator would have you believe
            self.tasks.sort(by: {$1.taskPriority < $0.taskPriority})
            self.tableView.reloadData()
        })
        
        //Refreshes the array/tableview when task is updated
        
        self.ref.child("users/\(user)/tasks").observe(FIRDataEventType.childChanged, with: {(snapshot) in print(snapshot)
            
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
            self.tasks.sort(by: {$1.taskPriority < $0.taskPriority})
            self.tableView.reloadData()
        })
        
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tasks.count == 0 {
            return 1
        } else {
            return tasks.count
        }
    }

    
    //Defines the cells textual data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PICell", for: indexPath) as! PICell
        
        if tasks.count == 0 {
            cell.taskLabel?.text = "You currently have no tasks"
            cell.priorityLabel?.text = ""
            return cell
        } else {
            let task = tasks[indexPath.row]
            cell.taskLabel?.text = task.taskName
            cell.priorityLabel?.text = "\(task.taskPriority)"
            return cell
        }
        
    }
 
    //Provides the user permission to swipe left to select option to delete
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //Allows the user to swipe left to select the option to delete
    //This will need to be revisted when the UI is overhauled
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            self.ref.child("users/\(user)/tasks/\(task.taskKey)").removeValue()
            self.tableView.reloadData()
        }
    }

    //Activates segue to EditTaskVC
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        performSegue(withIdentifier: "editSegue", sender: task)
    }
    
    //Provides the data to initialize an existing PITask to edit
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSegue"{
            let nextVC = segue.destination as! EditTaskVC
            nextVC.task = sender as! PITask
            
        }
    }
    

}
