//
//  AADatePicker.swift
//  Procrastinate It
//
//  Created by Steven Sherry on 5/12/17.
//  Copyright © 2017 Affinity for Apps. All rights reserved.
//

import Foundation
import UIKit

public class AADatePicker: UIDatePicker {
    let toolBar = UIToolbar()
    let dateFormatter = DateFormatter()
    var textField = UITextField()
    var viewsController = UIViewController()
    var button = UIButton()
    weak var delegate: AADatePickerDelegate?
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public init(viewController: UIViewController, textField: UITextField) {
        super.init(frame: CGRect(x: 0, y: viewController.view.frame.size.height - 216, width: viewController.view.frame.size.width, height: 216))
        self.viewsController = viewController
        self.backgroundColor = UIColor(red: 242/255, green: 243/255, blue: 251/255, alpha: 1)
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 0.29, green: 0.65, blue: 0.65, alpha: 1.0)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneTappedForTextField(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelTappedForTextField(_:)))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.minimumDate = Date()
        self.textField = textField
        textField.inputView = self
        textField.inputAccessoryView = toolBar
    }
    
    public init(viewController: UIViewController, button: UIButton) {
        super.init(frame: CGRect(x: 0, y: viewController.view.frame.size.height - 216, width: viewController.view.frame.size.width, height: 216))
        self.viewsController = viewController
        self.button = button
        self.backgroundColor = UIColor(red: 242/255, green: 243/255, blue: 251/255, alpha: 1)
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 0.29, green: 0.65, blue: 0.65, alpha: 1.0)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneTappedForButton(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelTappedForButton(_:)))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.minimumDate = Date()
        button.addTarget(self, action: #selector(self.buttonTapped(_:)), for: .touchUpInside)
        
    }

    
    func doneTappedForTextField(_ sender: UIBarButtonItem) -> Date {
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        textField.text = "\(dateFormatter.string(from: self.date))"
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        print("\(dateFormatter.string(from: self.date))")
        return self.date
    }
    
    func cancelTappedForTextField(_ sender: UIBarButtonItem) {
        self.textField.resignFirstResponder()
    }
    
    func doneTappedForButton(_ sender: UIBarButtonItem) {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        print("\(dateFormatter.string(from: self.date))")
        button.setTitle(dateFormatter.string(from: self.date), for: .normal)
    }
    
    func cancelTappedForButton(_ sender: UIBarButtonItem) {
        
    }
    
    func buttonTapped(_ sender: UIButton) {
        self.becomeFirstResponder()
    }
    
}
