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

class ProcrastinateVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    let ref = FIRDatabase.database().reference()
    let user = FIRAuth.auth()!.currentUser!.uid
    let dataService = DataService.instance
    
    override func viewWillAppear(_ animated: Bool) {
        //This removes all the PITasks from the static array, otherwise the local array adds duplicates
        DataService.tasks.removeAll()
        dataService.getTasks(user: user, ref: ref)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        dataService.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSegue"{
            let nextVC = segue.destination as! EditTaskVC
            nextVC.task = sender as! PITask
        }
    }
    
    @IBAction func addTapped(_ sender: Any) {
        //Sends a blank task to EditTaskVC to avoid a crash
        let blankTask = PITask(taskName: "", taskInfo: "", taskPriority: 0, taskInterval: 0, taskKey: "", taskDate: Date(), lastIncrease: Date(), isRecurring: false)
        performSegue(withIdentifier: "editSegue", sender: blankTask)
   }
    
    @IBAction func logoutTapped(_ sender: Any) {
        facebookLoginSuccess = false
        didLogOut = true
        AuthService.instance.logOut()
        self.dismiss(animated: true, completion: nil)
    }
}

extension ProcrastinateVC: DataServiceDelegate{
    func tasksLoaded() {
        print("delegate fired")
        self.tableView.reloadData()
    }
}

extension ProcrastinateVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if DataService.tasks.count == 0 {
            return 1
        } else {
            return DataService.tasks.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PICell", for: indexPath) as! PICell
        
        if DataService.tasks.count == 0 {
            cell.updateUI(cellTask: nil)
            return cell
        } else {
            let task = DataService.tasks[indexPath.row]
            cell.updateUI(cellTask: task)
            return cell
        }
    }
    
    //Provides the user permission to swipe left to select option to delete
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if DataService.tasks.count == 0 {
            return false
        } else {
            return true
        }
    }
    
    //Changes default delete action title from delete to "Completed"
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Complete"
    }
    
    //Allows the user to swipe left to select the option to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = DataService.tasks[indexPath.row]
            self.dataService.deleteOrResetTask(user: self.user, ref: self.ref, task: task)
        }
    }
    
    //Activates segue to EditTaskVC
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if DataService.tasks.count > 0 {
            let task = DataService.tasks[indexPath.row]
            performSegue(withIdentifier: "editSegue", sender: task)
        } else {
            performSegue(withIdentifier: "addSegue", sender: nil)
        }
    }
}


    
    

