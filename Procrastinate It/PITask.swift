//
//  PITask.swift
//  Procrastinate It
//
//  Created by Steven Sherry on 2/23/17.
//  Copyright © 2017 Affinity for Apps. All rights reserved.
//

import Foundation
class PITask {
    
    private var _taskName: String
    private var _taskInfo: String
    private var _originalPriority: Double
    private var _taskPriority: Double
    private var _taskInterval: Double
    private var _taskKey: String
    private var _taskDate: Date
    private var _lastIncrease: Date
    private var _completeBy: Date
    private var _isRecurring: Bool
    
    var taskName: String {
        get {
            return _taskName
        } set {
            _taskName = newValue
        }
    }
    
    var taskInfo: String {
        get {
            return _taskInfo
        } set {
            _taskInfo = newValue
        }
    }
    
    var originalPriority: Double {
        return _originalPriority
    }
    
    var taskPriority: Double {
        get {
            return _taskPriority
        } set {
            _taskPriority = newValue
        }
    }
    
    var taskInterval: Double {
        return _taskInterval
    }
    
    var taskKey: String {
        return _taskKey
    }
    
    var taskDate: Date {
        get {
            return _taskDate
        } set {
            _taskDate = newValue
        }
    }
    
    var lastIncrease: Date {
        get {
            return _lastIncrease
        } set {
            _lastIncrease = newValue
        }
    }
    
    var completeBy: Date {
        get {
            return _completeBy
        } set {
            _completeBy = newValue
        }
    }
    
    var isRecurring: Bool {
        get {
            return _isRecurring
        } set {
            _isRecurring = newValue
        }
    }
    
    init(taskName: String, taskInfo: String, taskPriority: Double, taskInterval: Double, taskKey: String, taskDate: Date, lastIncrease: Date, isRecurring: Bool){
        
        let baseDate = Date()
        self._taskName = taskName
        self._taskInfo = taskInfo
        self._originalPriority = taskPriority
        self._taskPriority = taskPriority
        self._taskInterval = taskInterval
        self._taskKey = taskKey
        self._taskDate = taskDate
        self._lastIncrease = lastIncrease
        self._isRecurring = isRecurring
        self._completeBy = baseDate.addingTimeInterval(60)
        
    }
    
    init(taskName: String, taskInfo: String, taskPriority: Double, taskKey: String, taskDate: Date, lastIncrease: Date, isRecurring: Bool, completeBy: Date) {
        
        self._taskName = taskName
        self._taskInfo = taskInfo
        self._originalPriority = taskPriority
        self._taskPriority = taskPriority
        self._taskInterval = PITask.setInterval(priority: taskPriority, startDate: taskDate, endDate: completeBy)
        self._taskKey = taskKey
        self._taskDate = taskDate
        self._lastIncrease = lastIncrease
        self._isRecurring = isRecurring
        self._completeBy = completeBy
        
    }
    
    private static func setInterval(priority: Double, startDate: Date, endDate: Date) -> Double {
        let secondsInDay: Double = 60*60*24
        let totalDaysToIncrease = endDate.timeIntervalSince(startDate)/secondsInDay
        return (10 - priority)/totalDaysToIncrease
    }
    
}




