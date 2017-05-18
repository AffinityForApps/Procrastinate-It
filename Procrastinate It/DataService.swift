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

class DataService {
    
    static let instance = DataService()
    weak var delegate: DataServiceDelegate?
    
    var currentDate = Date()
    var firebaseObserver: FIRDataEventType?
    let secondsInDay = 60*60*24
    let dateFormatter = DateFormatter()
    
    static public var tasks: [PITask] = []
    
    private init(){}
    
    func getTasks(user: String, ref: FIRDatabaseReference, userAction: PITaskUserAction) {
        //Case-sensitivity is important for date/time format (eg. if mm is put instead of MM for the month, it will return minutes instead)
        
        switch userAction{
            case .added: firebaseObserver = .childAdded
            
            case .changed: firebaseObserver = .childChanged
            
            case .deleted: firebaseObserver = .childRemoved
        }
        
        fetchTasks(user: user, ref: ref, firDataEvent: firebaseObserver!)
    }

    
    private func fetchTasks(user: String, ref: FIRDatabaseReference, firDataEvent: FIRDataEventType) {
        DataService.tasks.removeAll()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        ref.child("users/\(user)/tasks").observe(firDataEvent, with: {(snapshot) in print(snapshot)
            print("In child added observer")
            let snapshotDictionary = snapshot.value as? [String:Any]
            
            if firDataEvent == .childChanged || firDataEvent == .childRemoved {
                self.popTask(snapshot: snapshot)
            }
            
            //Initializing task with Firebase data
            
            let task = PITask(taskName: snapshotDictionary!["Task Name"] as! String,
                              taskInfo: snapshotDictionary!["Task Info"] as! String,
                              taskPriority: snapshotDictionary!["Task Priority"] as! Double,
                              taskInterval: snapshotDictionary!["Task Interval"] as! Double,
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

    }
    
    // Date manipulation to increase taskPriority by taskInterval for each day passed..
    private func increaseTaskPriority(user: String, ref: FIRDatabaseReference) {
        var index = 0
        for task in DataService.tasks{
            if task.lastIncrease != self.currentDate {
                let days = self.currentDate.timeIntervalSince(task.lastIncrease)/Double(self.secondsInDay)
                if days > 1 {
                    task.taskPriority += task.taskInterval * days
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
    
    private func popTask(snapshot: FIRDataSnapshot) {
        var index = 0
        for task in DataService.tasks{
            if snapshot.key == task.taskKey{
                DataService.tasks.remove(at: index)
            }
            index += 1
        }
    }
    
    //Previously had this in two separate functions "addTask" and "editTask"; consolidated for caller brevity
    func uploadTask(user: String, ref: FIRDatabaseReference, taskKey: String, firTask: [String: Any]) {
        if taskKey == "" {
            ref.child("users/\(user)/tasks").childByAutoId().setValue(firTask)
        } else {
            ref.child("users/\(user)/tasks/\(taskKey)").updateChildValues(firTask)
        }
    }
    
    func prepareForFirebaseUpload(user: String, ref: FIRDatabaseReference, task: PITask) -> [String: Any] {
        //Firebase cannot take Date as a value so it has to be converted to a string.
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedTaskDate = dateFormatter.string(from: task.taskDate)
        let formattedLastIncrease = dateFormatter.string(from: task.lastIncrease)
        let firTask = ["Task Name":task.taskName,"Task Info":task.taskInfo,"Task Priority":task.taskPriority,"Task Interval":task.taskInterval, "Task Date": formattedTaskDate, "Last Increase":formattedLastIncrease,"Recurring": task.isRecurring] as [String: Any]
        return firTask
    }
    
    /*
    This handles a bug where a task was being appended to DataService.tasks multiple times, even though
    it wasn't created in Firebase multiple times. I wasn't able to exactly nail down where and why it was 
    happening, so this method was created to keep it from happening. The bug would typically only occur
    when a new task ws created but it was relatively unpredictable because it wouldn't happen every time, 
    which made it even more difficult to figure out. This fix will have to do for now.
    */
    private func nonDuplicateTaskVerification(task: PITask) {
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

protocol DataServiceDelegate: class {

    func tasksLoaded()

}



