//
//  AppDelegateExtension.swift
//  ExpensesTracker
//
//  Created by Comonfort on 6/26/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit
import UserNotifications
import AudioToolbox.AudioServices

extension AppDelegate : UNUserNotificationCenterDelegate {
    
    //Called when a notification is about to be delivered
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        let configuration = CoreDataManager(inContext: self).getLatestNSObject(forEntity: "Configuration", latestByKey: "authentication") as! Configuration;
        
        //No permission to notificate
        if (!configuration.shouldNotificate (notificationOfType: ESettingStrings.Notifications)) {
            return;
        }
        
        let catID = notification.request.content.categoryIdentifier;
        
        //Check for each category, if its setting is active
        if (catID == ENotificationCategoryIDs.budget.rawValue) {
            
            if (configuration.shouldNotificate (notificationOfType: ESettingStrings.BudgetNotification)) {
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate));
                completionHandler([.alert, .badge, .sound]);
            }
            
        }
        else if (catID == ENotificationCategoryIDs.recurrentEvent.rawValue) {
            
            if (configuration.shouldNotificate (notificationOfType: ESettingStrings.BudgetNotification)) {
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate));
                completionHandler([.alert, .badge, .sound]);
            }
        }
        else if (catID == ENotificationCategoryIDs.squander.rawValue) {
            
            if (configuration.shouldNotificate (notificationOfType: ESettingStrings.BudgetNotification)) {
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate));
                completionHandler([.alert, .badge, .sound]);
            }
        }
        else {
            print("Unrecognized notification category. Not presenting it");
            return;
        }
        
    }
    
    //Called after the user gets the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
            // Handle the action performed by the user
            if response.actionIdentifier == UNNotificationDismissActionIdentifier {
                // The user dismissed the notification without taking action
            }
            else if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
                // The user launched the app
            }
            
        completionHandler()
    }

}
