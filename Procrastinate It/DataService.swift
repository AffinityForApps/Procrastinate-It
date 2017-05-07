//
//  DataService.swift
//  Procrastinate It
//
//  Created by Steven Sherry on 5/6/17.
//  Copyright © 2017 Affinity for Apps. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

protocol DataServiceDelegate: class {
    func tasksLoaded()
}

class DataService {
    
    static let instance = DataService()
    weak var delegate: DataServiceDelegate?
    
    var currentDate = Date()
    let secondsInDay = 60*60*24
    let dateFormatter = DateFormatter()
    
    static var tasks: [PITask] = []
    
    func getTasks(user: String, ref: FIRDatabaseReference){
        //Case-sensitivity is important for date/time format (eg. if mm is put instead of MM for the month, it will return minutes instead)
        DataService.tasks.removeAll()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        ref.child("users/\(user)/tasks").observe(FIRDataEventType.childAdded, with: {(snapshot) in print(snapshot)
            print("In child added observer")
            let snapshotDictionary = snapshot.value as? [String:Any]
            
            //Initializing task with Firebase data
            
            let task = PITask(taskName: snapshotDictionary!["Task Name"] as! String,
                              taskInfo: snapshotDictionary!["Task Info"] as! String,
                              taskPriority: snapshotDictionary!["Task Priority"] as! Int,
                              taskInterval: snapshotDictionary!["Task Interval"] as! Int,
                              taskKey: snapshot.key,
                              taskDate: self.dateFormatter.date(from: snapshotDictionary!["Task Date"] as! String)! as Date,
                              lastIncrease: self.dateFormatter.date(from: snapshotDictionary!["Last Increase"] as! String)! as Date,
                              isRecurring: snapshotDictionary!["Recurring"] as! Bool)
            
            self.nonDuplicateTaskVerification(task: task)
        
            self.increaseTaskPriority(user: user, ref: ref)
            
            //sorts in descending order by task priority, contrary to what the comparison operator would have you believe
            DataService.tasks.sort(by: {$1.taskPriority < $0.taskPriority})
            self.delegate?.tasksLoaded()
        })
        
        /*
         Refreshes the data when a task has been changed. For some reason the object was able to refresh
         the integer variables being string interpolated, but not string variables so the object had to
         be deleted from the the array and re-appended.
         */
        
        ref.child("users/\(user)/tasks").observe(FIRDataEventType.childChanged, with: {(snapshot) in print(snapshot)
            
            print("in child changed observer")
            var index = 0
            for task in DataService.tasks{
                if snapshot.key == task.taskKey{
                    DataService.tasks.remove(at: index)
                }
                index += 1
            }
            
            let snapshotDictionary = snapshot.value as? NSDictionary
            
            //Initializing task with Firebase data
            
            let task = PITask(taskName: snapshotDictionary!["Task Name"] as! String,
                              taskInfo: snapshotDictionary!["Task Info"] as! String,
                              taskPriority: snapshotDictionary!["Task Priority"] as! Int,
                              taskInterval: snapshotDictionary!["Task Interval"] as! Int,
                              taskKey: snapshot.key,
                              taskDate: self.dateFormatter.date(from:snapshotDictionary!["Task Date"] as! String)!,
                              lastIncrease: self.dateFormatter.date(from: snapshotDictionary!["Last Increase"] as! String)! as Date,
                              isRecurring: snapshotDictionary!["Recurring"] as! Bool)
            
            self.nonDuplicateTaskVerification(task: task)
            
            self.increaseTaskPriority(user: user, ref: ref)
            
            //sorts in descending order, contrary to what the comparison operator would have you believe
            DataService.tasks.sort(by: {$1.taskPriority < $0.taskPriority})
            self.delegate?.tasksLoaded()
        })
        
        //Pops task from array when deleted
        
        ref.child("users/\(user)/tasks").observe(FIRDataEventType.childRemoved, with: {(snapshot) in print(snapshot)
            print("In child removed observer")
            var index = 0
            for task in DataService.tasks{
                if snapshot.key == task.taskKey{
                    DataService.tasks.remove(at: index)
                }
                index += 1
            }
            
            self.increaseTaskPriority(user: user, ref: ref)
            
            //sorts in descending order, contrary to what the comparison operator would have you believe
            DataService.tasks.sort(by: {$1.taskPriority < $0.taskPriority})
            self.delegate?.tasksLoaded()
        })
        
    }
    
    // Date manipulation to increase taskPriority by taskInterval for each day passed..
    func increaseTaskPriority(user: String, ref: FIRDatabaseReference){
        var index = 0
        for task in DataService.tasks{
            if task.lastIncrease != self.currentDate {
                let days = self.currentDate.timeIntervalSince(task.lastIncrease)/Double(self.secondsInDay)
                if days > 1 {
                    task.taskPriority += task.taskInterval * Int(days)
                    if task.taskPriority >= 10{
                        task.taskPriority = 10
                    }
                    task.lastIncrease = self.currentDate
                    ref.child("users/\(user)/tasks/\(task.taskKey)/Last Increase").setValue(self.dateFormatter.string(from: task.lastIncrease))
                    ref.child("users/\(user)/tasks/\(task.taskKey)/Task Priority").setValue(task.taskPriority)
                }
                
            }
            index += 1
        }
    }

    //Performed when the user swipes left to mark as complete
    func deleteOrResetTask(user: String, ref: FIRDatabaseReference, task: PITask) {
        if task.isRecurring{
            ref.child("users/\(user)/tasks/\(task.taskKey)/Task Priority").setValue(0)
            self.delegate?.tasksLoaded()
            
        } else if !task.isRecurring{
            ref.child("users/\(user)/tasks/\(task.taskKey)").removeValue()
            self.delegate?.tasksLoaded()
        }
    }
    
    func addTask(user: String, ref: FIRDatabaseReference, firTask: Dictionary<String, Any>){
        ref.child("users/\(user)/tasks").childByAutoId().setValue(firTask)
    }
    
    func editTask(user: String, ref: FIRDatabaseReference, taskKey: String, firTask: Dictionary<String, Any>){
        ref.child("users/\(user)/tasks/\(taskKey)").updateChildValues(firTask)
    }
    
    func prepareForFirebaseUpload(user: String, ref: FIRDatabaseReference, task: PITask) -> Dictionary<String, Any>{
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = dateFormatter.string(from: currentDate)
        let task = ["Task Name":task.taskName,"Task Info":task.taskInfo,"Task Priority":task.taskPriority,"Task Interval":task.taskInterval, "Task Date": formattedDate, "Last Increase":formattedDate,"Recurring": task.isRecurring] as Dictionary<String, Any>
        return task
    }
    
    /*
    This handles a bug where a task was being appended to DataService.tasks multiple times, even though
    it wasn't created in Firebase multiple times. I wasn't able to exactly nail down where and why it was 
    happening, so this method was created to keep it from happening. The bug would typically only occur
    when a new task ws created but it was relatively unpredictable because it wouldn't happen every time, 
    which made it even more difficult to figure out. This fix will have to do for now.
    */
    func nonDuplicateTaskVerification(task: PITask){
        let alreadyInArray = DataService.tasks.contains(where: { (inArray) -> Bool in
            if inArray.taskKey == task.taskKey {
                return true
            } else {
                return false
            }
        })
        
        if !alreadyInArray {
            DataService.tasks.append(task)
        } else {
            print("Already in array and didn't append")
        }
    }
    
}
