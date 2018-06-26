//
//  NotificationsManager.swift
//  ExpensesTracker
//
//  Created by Comonfort on 6/26/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationsManager {
    
    /*
    Schedules a notification to ring at the specified date, with the given message.
     Returns a string indicating the id of the notifications if succesful, returns nil otherwise.
    */
    static func scheduleNotification(date: Date, message: String) -> String?
    {
        let content = UNMutableNotificationContent()
        
        //Set content
        content.title = NSString.localizedUserNotificationString(forKey: message, arguments: nil)
        
        //Create time trigger
        let targetDateComp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: targetDateComp, repeats: false)
        
        // Create the request object.
        let customFormatter = CustomFormatter();
        var notificationID: String? = customFormatter.formatDate(date: date) + "-" + message.trimmingCharacters(in: .whitespaces);
        let request = UNNotificationRequest(identifier: notificationID!, content: content, trigger: trigger)
        
        // Schedule the request.
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription);
                notificationID = nil;
            }
        }
        
        return notificationID;
    }

}
