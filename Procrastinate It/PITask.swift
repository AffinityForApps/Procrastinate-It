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
    private var _taskPriority: Int
    private var _taskInterval: Int
    private var _taskKey: String
    private var _taskDate: Date
    private var _lastIncrease: Date
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
    
    var taskPriority: Int {
        get {
            return _taskPriority
        } set {
            _taskPriority = newValue
        }
    }
    
    var taskInterval: Int {
        get {
            return _taskInterval
        } set {
            _taskInterval = newValue
        }
    }
    
    var taskKey: String {
        get {
            return _taskKey
        } set {
            _taskKey = newValue
        }
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
    
    var isRecurring: Bool {
        get {
            return _isRecurring
        } set {
            _isRecurring = newValue
        }
    }
    
    init(taskName: String, taskInfo: String, taskPriority: Int, taskInterval: Int, taskKey: String, taskDate: Date, lastIncrease: Date, isRecurring: Bool){
        
        self._taskName = taskName
        self._taskInfo = taskInfo
        self._taskPriority = taskPriority
        self._taskInterval = taskInterval
        self._taskKey = taskKey
        self._taskDate = taskDate
        self._lastIncrease = lastIncrease
        self._isRecurring = isRecurring
        
    }
    
}




