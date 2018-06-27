//
//  NotificationsManager.swift
//  ExpensesTracker
//
//  Created by Comonfort on 6/26/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit
import UserNotifications

enum ENotificationCategoryIDs: String {
    case budget = "budget_notification_category"
    case recurrentEvent = "recurrentEvent_notification_category"
    case squander = "squander_notification_category"
}

class NotificationsManager {
    
    static func askForNotificationsPermission(){
        let center = UNUserNotificationCenter.current()
    
        //Request notification permissions, only asked once
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
    
        }
        
        let budgetCategory = UNNotificationCategory(
                                  identifier: ENotificationCategoryIDs.budget.rawValue,
                                  actions: [],
                                  intentIdentifiers: [],
                                  options: [UNNotificationCategoryOptions.allowInCarPlay,
                                            UNNotificationCategoryOptions.hiddenPreviewsShowTitle ]);
        let recurrentEventCategory = UNNotificationCategory(
                                    identifier: ENotificationCategoryIDs.recurrentEvent.rawValue,
                                    actions: [],
                                    intentIdentifiers: [],
                                    options: [UNNotificationCategoryOptions.allowInCarPlay,
                                              UNNotificationCategoryOptions.hiddenPreviewsShowTitle ]);
        
        center.setNotificationCategories([budgetCategory, recurrentEventCategory]);
        
    }
    
    /*
    Schedules a notification to ring at the specified date, with the given message.
     Returns a string indicating the id of the notifications if succesful, returns nil otherwise.
    */
    static func scheduleNotification(fromCategory notificationCategory: ENotificationCategoryIDs, atDate date: Date, withMessage message: String) -> String?
    {
        //Check the user has given permission to send notifications, otherwise don't fulfill this request
        if (!hasUserPermission())
        {
            print("User has denied permissions, can't schedule notification");
            askForNotificationsPermission();
            return nil;
        }
        
        let content = UNMutableNotificationContent()
        
        //Set content
        content.title = NSString.localizedUserNotificationString(forKey: message, arguments: nil);
        content.sound = UNNotificationSound.default();
        content.categoryIdentifier = notificationCategory.rawValue;
        
        //Create time trigger
        var trigger: UNNotificationTrigger;
        if (date <= Date()) {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: (2), repeats: false)
        }
        else {
            let targetDateComp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            
            trigger = UNCalendarNotificationTrigger(dateMatching: targetDateComp, repeats: false)
        }
        
        // Create the request object.
        let customFormatter = CustomFormatter();
        var notificationID: String? = customFormatter.formatDate(date: date) + "-" + message.trimmingCharacters(in: .whitespaces);
        let request = UNNotificationRequest(identifier: notificationID!, content: content, trigger: trigger);
        
        // Schedule the request.
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let theError = error {
                print("\nNotification request error!\n" + theError.localizedDescription);
                notificationID = nil;
            }
            else {
                print ("Succesfully scheduled notification");
            }
        }

        return notificationID;
    }

    static func hasUserPermission() -> Bool {
        
        var hasPermission: Bool = false;
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                hasPermission = true;
            }
            else {
                hasPermission = false;
            }
        }

        return hasPermission;
    }
    
}
