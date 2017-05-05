//
//  MaterialView.swift
//  DreamLister
//
//  Created by Steven Sherry on 2/17/17.
//  Copyright © 2017 Affinity for Apps. All rights reserved.
//

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
//                //// General Declarations
//                let context = UIGraphicsGetCurrentContext()!
//
//                //// Color Declarations
////                let fillColor = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 1.000)
//                let fillColor2 = UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1.000)
//                
//                
//                
//                //// Shadow Declarations
//                let shadow2 = NSShadow()
//                shadow2.shadowColor = fillColor2
//                shadow2.shadowOffset = CGSize(width: 1, height: 2)
//                shadow2.shadowBlurRadius = 4
//                
//                //// Page-1
//                context.saveGState()
//                context.setShadow(offset: shadow2.shadowOffset, blur: shadow2.shadowBlurRadius, color: (shadow2.shadowColor as! UIColor).cgColor)
//                context.setAlpha(0.9)
//                context.beginTransparencyLayer(auxiliaryInfo: nil)
                
                
                
//                self.layer.masksToBounds = false
//                self.layer.cornerRadius = 3.0
//                self.layer.shadowOpacity = 0.8
//                self.layer.shadowRadius = 3.0
//                self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
//                self.layer.shadowColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1.0).cgColor
                
            } else {
                
                self.layer.cornerRadius = 0
                self.layer.shadowOpacity = 0
                self.layer.shadowRadius = 0
                self.layer.shadowColor = nil
                
            }
            
        }
        
    }


}
