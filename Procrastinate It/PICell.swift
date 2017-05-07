//
//  PICell.swift
//  Procrastinate It
//
//  Created by Steven Sherry on 2/25/17.
//  Copyright © 2017 Affinity for Apps. All rights reserved.
//

import UIKit

class PICell: UITableViewCell {

    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateUI(cellTask: PITask?){
        
        if let task = cellTask {
            taskLabel.text = task.taskName
            detailsLabel.text = task.taskInfo
            priorityLabel.text = "\(task.taskPriority)"
            if task.taskPriority >= 10 {
                cellView.layer.shadowColor = UIColor(red: 0.99, green: 0.06, blue: 0.06, alpha: 0.70).cgColor
            } else {
                cellView.layer.shadowColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.90).cgColor
            }
        } else {
            taskLabel.text = "You currently have no tasks"
            detailsLabel.text = ""
            priorityLabel.text = ""
        }
        
    }
    
}
