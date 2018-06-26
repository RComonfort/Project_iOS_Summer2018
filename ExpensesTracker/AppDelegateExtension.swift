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
    
    //Called when a notification is delivered with the app in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate));
        
        completionHandler([.alert, .badge, .sound]);
        
        //Notification was delivered by this point
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
