//
//  AABarButtonItem.swift
//  Procrastinate It
//
//  Created by Steven Sherry on 5/13/17.
//  Copyright © 2017 Affinity for Apps. All rights reserved.
//

import Foundation
import UIKit

class AABarButtonItem: UIBarButtonItem {
    override open class func initialize() {
        
        superclass()?.initialize()
        
        //Tint color
        self.appearance().tintColor = nil
        
        //Title
        self.appearance().setTitlePositionAdjustment(UIOffset.zero, for: UIBarMetrics.default)
        self.appearance().setTitleTextAttributes(nil, for: UIControlState())
        self.appearance().setTitleTextAttributes(nil, for: UIControlState.highlighted)
        self.appearance().setTitleTextAttributes(nil, for: UIControlState.disabled)
        self.appearance().setTitleTextAttributes(nil, for: UIControlState.selected)
        self.appearance().setTitleTextAttributes(nil, for: UIControlState.application)
        self.appearance().setTitleTextAttributes(nil, for: UIControlState.reserved)
        
        //Background Image
        self.appearance().setBackgroundImage(nil, for: UIControlState(),      barMetrics: UIBarMetrics.default)
        self.appearance().setBackgroundImage(nil, for: UIControlState.highlighted, barMetrics: UIBarMetrics.default)
        self.appearance().setBackgroundImage(nil, for: UIControlState.disabled,    barMetrics: UIBarMetrics.default)
        self.appearance().setBackgroundImage(nil, for: UIControlState.selected,    barMetrics: UIBarMetrics.default)
        self.appearance().setBackgroundImage(nil, for: UIControlState.application, barMetrics: UIBarMetrics.default)
        self.appearance().setBackgroundImage(nil, for: UIControlState.reserved,    barMetrics: UIBarMetrics.default)
        
        self.appearance().setBackgroundImage(nil, for: UIControlState(),      style: UIBarButtonItemStyle.done, barMetrics: UIBarMetrics.default)
        self.appearance().setBackgroundImage(nil, for: UIControlState.highlighted, style: UIBarButtonItemStyle.done, barMetrics: UIBarMetrics.default)
        self.appearance().setBackgroundImage(nil, for: UIControlState.disabled,    style: UIBarButtonItemStyle.done, barMetrics: UIBarMetrics.default)
        self.appearance().setBackgroundImage(nil, for: UIControlState.selected,    style: UIBarButtonItemStyle.done, barMetrics: UIBarMetrics.default)
        self.appearance().setBackgroundImage(nil, for: UIControlState.application, style: UIBarButtonItemStyle.done, barMetrics: UIBarMetrics.default)
        self.appearance().setBackgroundImage(nil, for: UIControlState.reserved,    style: UIBarButtonItemStyle.done, barMetrics: UIBarMetrics.default)
        
        self.appearance().setBackgroundImage(nil, for: UIControlState(),      style: UIBarButtonItemStyle.plain, barMetrics: UIBarMetrics.default)
        self.appearance().setBackgroundImage(nil, for: UIControlState.highlighted, style: UIBarButtonItemStyle.plain, barMetrics: UIBarMetrics.default)
        self.appearance().setBackgroundImage(nil, for: UIControlState.disabled,    style: UIBarButtonItemStyle.plain, barMetrics: UIBarMetrics.default)
        self.appearance().setBackgroundImage(nil, for: UIControlState.selected,    style: UIBarButtonItemStyle.plain, barMetrics: UIBarMetrics.default)
        self.appearance().setBackgroundImage(nil, for: UIControlState.application, style: UIBarButtonItemStyle.plain, barMetrics: UIBarMetrics.default)
        self.appearance().setBackgroundImage(nil, for: UIControlState.reserved,    style: UIBarButtonItemStyle.plain, barMetrics: UIBarMetrics.default)
        self.appearance().setBackgroundVerticalPositionAdjustment(0, for: UIBarMetrics.default)
        
        //Back Button
        self.appearance().setBackButtonBackgroundImage(nil, for: UIControlState(),      barMetrics: UIBarMetrics.default)
        self.appearance().setBackButtonBackgroundImage(nil, for: UIControlState.highlighted, barMetrics: UIBarMetrics.default)
        self.appearance().setBackButtonBackgroundImage(nil, for: UIControlState.disabled,    barMetrics: UIBarMetrics.default)
        self.appearance().setBackButtonBackgroundImage(nil, for: UIControlState.selected,    barMetrics: UIBarMetrics.default)
        self.appearance().setBackButtonBackgroundImage(nil, for: UIControlState.application, barMetrics: UIBarMetrics.default)
        self.appearance().setBackButtonBackgroundImage(nil, for: UIControlState.reserved,    barMetrics: UIBarMetrics.default)
        
        self.appearance().setBackButtonTitlePositionAdjustment(UIOffset.zero, for: UIBarMetrics.default)
        self.appearance().setBackButtonBackgroundVerticalPositionAdjustment(0, for: UIBarMetrics.default)
    }

}
