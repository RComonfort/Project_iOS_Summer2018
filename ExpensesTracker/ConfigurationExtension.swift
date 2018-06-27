//
//  ConfigurationExtension.swift
//  ExpensesTracker
//
//  Created by Alumno on 27/06/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit

extension Configuration{
    
    func shouldNotificate(notificationOfType type: ESettingStrings) -> Bool{
        switch type {
        case ESettingStrings.Notifications:
            return self.notifications
        case ESettingStrings.BudgetNotification:
            return self.notifications && self.budget
        case ESettingStrings.RecurrentNotification:
            return self.notifications && self.recurrent
        case ESettingStrings.SquanderNotification:
            return self.notifications && self.squander
        default:
            return false
        }
    }
    
}
