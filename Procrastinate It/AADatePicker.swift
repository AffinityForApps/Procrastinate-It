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
    weak var delegate: AADatePickerDelegate?
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public init(viewController: UIViewController) {
        super.init(frame: CGRect(x: 0, y: viewController.view.frame.size.height - 216, width: viewController.view.frame.size.width, height: 216))
        self.backgroundColor = UIColor(red: 242/255, green: 243/255, blue: 251/255, alpha: 1)
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 0.29, green: 0.65, blue: 0.65, alpha: 1.0)
        toolBar.sizeToFit()
        let doneButton = AABarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped(sender:)))
        let spaceButton = AABarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = AABarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelTapped))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.minimumDate = Date()
        self.addSubview(toolBar)
    }

    
    func doneTapped(sender: Any) -> Date {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        print("\(self.date)")
        return self.date
    }
    
    func cancelTapped() {
        self.removeFromSuperview()
    }
    
}
