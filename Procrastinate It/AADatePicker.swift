//
//  AADatePicker.swift
//  Procrastinate It
//
//  Created by Steven Sherry on 5/12/17.
//  Copyright © 2017 Affinity for Apps. All rights reserved.
//

import Foundation
import UIKit

class AADatePicker: UIDatePicker {
    let toolBar = UIToolbar()
    let dateFormatter = DateFormatter()
    var textField = UITextField()
    var viewsController = UIViewController()
    var label: UILabel!
    var task: PITask?
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(viewController: UIViewController, label: UILabel, textField: UITextField, task: PITask) {
        super.init(frame: CGRect(x: 0, y: viewController.view.frame.size.height - 216, width: viewController.view.frame.size.width, height: 216))
        self.viewsController = viewController
        self.label = label
        self.task = task
        self.backgroundColor = UIColor(red: 242/255, green: 243/255, blue: 251/255, alpha: 1)
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 0.29, green: 0.65, blue: 0.65, alpha: 1.0)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneTappedForButton(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelTappedForTextField(_:)))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.minimumDate = Date()
        self.textField = textField
        textField.inputView = self
        textField.inputAccessoryView = toolBar
    }
    
    func cancelTappedForTextField(_ sender: UIBarButtonItem) {
        self.textField.resignFirstResponder()
    }
    
    func doneTappedForButton(_ sender: UIBarButtonItem) {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let task = self.task {
            if let date = dateFormatter.date(from: dateFormatter.string(from: self.date)) {
                task.completeBy = date
            }
        }
        print("\(String(describing: task?.completeBy))")
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        label.text = "Deadline:\n \(dateFormatter.string(from: self.date))"
        self.textField.resignFirstResponder()
    }
    
}
