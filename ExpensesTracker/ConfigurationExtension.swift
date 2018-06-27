//
//  ConfigurationExtension.swift
//  ExpensesTracker
//
//  Created by Alumno on 27/06/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit

extension Configuration{
    
    func shouldNotificate(_ notificationType: String) -> Bool{
        switch notificationType {
        case "notification":
            return self.notifications
        case "budget":
            return self.notifications && self.budget
        case "recurrent":
            return self.notifications && self.recurrent
        case "squander":
            return self.notifications && self.squander
        default:
            return false
        }
    }
    
}
