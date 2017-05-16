//
//  PanicMonster.swift
//  Procrastinate It
//
//  Created by Steven Sherry on 5/12/17.
//  Copyright © 2017 Affinity for Apps. All rights reserved.
//

import Foundation
import UserNotifications

class PanicMonster {
    
    static let instance = PanicMonster()
    
    private init(){}
    
    func scheduleNotification(forTask: PITask) {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: forTask.completeBy)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        let content = UNMutableNotificationContent()
        content.title = forTask.taskName
        content.body = "Good job, you failed yourself"
        content.sound = UNNotificationSound.default()
        content.badge = 1
        let request = UNNotificationRequest(identifier: forTask.taskKey, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print("Uh oh! We had an error: \(error)")
            }
        }
    }
}
