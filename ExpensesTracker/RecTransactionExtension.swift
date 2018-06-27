//
//  RecTransactionExtension.swift
//  ExpensesTracker
//
//  Created by Alumno on 27/06/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit

extension RecTransaction{
    
    func addTransaction(coreDataManager: CoreDataManager){
        print("add transaction")
        let values = [self.amount, Date(), self.descriptionText ?? "", true, self.type!, coreDataManager.findCategory(ofType: self.type!, withName: (self.category?.name)!)!] as [Any]
        let keys = ["amount", "date", "descriptionText", "isAddedByRecurrent", "type", "category"]
        
        _ = coreDataManager.createAndSaveNSObject(forEntity: "Transaction", values: values, keys: keys)
        
        
        //Balance.updateBalanceAmount(amount: (self.type.lowercased() == "expense" ? -(self.amount) : self.amount), coreDataManager: coreDataManager)
        
        if self.type?.lowercased() == "expense" {
            Budget.updateBudgetSpenditure(amount * -1, coreDataManager: coreDataManager)
        }
        
        let config = coreDataManager.getLatestNSObject(forEntity: "Configuration", latestByKey: "notifications") as! Configuration
        
        if config.shouldNotificate(notificationOfType: ESettingStrings.RecurrentNotification) {
            _ = NotificationsManager.scheduleNotification(fromCategory: ENotificationCategoryIDs.recurrentEvent, atDate: Date(), withMessage: "A new \(self.type ?? "transaction") has been done");
        }
    }
    
    static func doRecurrentTransactions(coreDataManager: CoreDataManager){
        print("do recurrents")
        guard let allRecurrentNS = coreDataManager.getNSObjects(forEntity: "RecTransaction") else{
            print("no recurrents")
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let allRecurrents = allRecurrentNS as! [RecTransaction]
        
        for i in allRecurrents{
            let recPlusInterval = Date(timeInterval: Double(getTimeInterval(interval: i.recurrentInterval!)), since: i.recurrentBeginDate!)
            let today = Date()
            
            if formatter.string(from: recPlusInterval).lowercased() == formatter.string(from: today).lowercased() {
                i.addTransaction(coreDataManager: coreDataManager)
                _ = coreDataManager.updateNSObject(object: i, values: [today], keys: ["recurrentBeginDate"])
            }
        }
        
    }
    
    static func getTimeInterval(interval: String) -> Int{
        let intervalStrin = DefaultData.getTimeIntervals()
        let intervalInt = DefaultData.getTimeIntervalsSeconds()
        
        for i in 0..<intervalStrin.count{
            if intervalStrin[i].lowercased() == interval.lowercased(){
                return intervalInt[i]
            }
        }
        return 0
    }
    
}
