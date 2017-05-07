//
//  MaterialView.swift
//  DreamLister
//
//  Created by Steven Sherry on 2/17/17.
//  Copyright © 2017 Affinity for Apps. All rights reserved.
//

//Extension for setting the cellView properties
import UIKit
private var materialKey = false

extension UIView {

    @IBInspectable var materialDesign: Bool {
        
        get{
            
            return materialKey
            
        }
        set {
            
            materialKey = newValue
            
            if materialKey {
                
                self.layer.masksToBounds = false
                self.layer.cornerRadius = 10
                self.layer.shadowOpacity = 1.0
                self.layer.shadowRadius = 3.0
                self.layer.shadowOffset = CGSize(width: 2.0, height: 1.0)
                self.layer.shadowColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.90).cgColor
                
            } else {
                
                self.layer.cornerRadius = 0
                self.layer.shadowOpacity = 0
                self.layer.shadowRadius = 0
                self.layer.shadowColor = nil
                
            }
            
        }
        
    }


}
