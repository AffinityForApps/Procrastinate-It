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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
