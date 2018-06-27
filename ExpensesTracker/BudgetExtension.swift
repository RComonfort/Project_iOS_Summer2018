//
//  ClassExtensions.swift
//  ExpensesTracker
//
//  Created by Comonfort on 6/26/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit

extension Budget {
    static func updateBudgetSpenditure(_ amount: Double, coreDataManager: CoreDataManager) {
        
        //Only update if on a budget
        guard let budgetObj = coreDataManager.getLatestNSObject(forEntity: "Budget", latestByKey: "budgetBeginDate") else {
            return;
        }
        
        let spentAmount = (budgetObj.value(forKey: "spentAmount") as! Double) + amount;
        
        _ = coreDataManager.updateNSObject(object: budgetObj, values: [spentAmount], keys: ["spentAmount"]);
    }
    
    //Checks if the current expenditure surpases the budget warning amount.
    //If it does, send a notification
    static func checkBudgetLimit(coreDataManager: CoreDataManager) {
        
        //Obtain budget
        guard let budgetObj = coreDataManager.getLatestNSObject(forEntity: "Budget", latestByKey: "budgetBeginDate") else {
            return;
        }
        
        let spentAmount = (budgetObj.value(forKey: "spentAmount") as! Double);
        let warning = (budgetObj.value(forKey: "limitWarningAmount") as! Double);
        let budgetLimit = (budgetObj.value(forKey: "limit") as! Double);
        //_ = coreDataManager.updateNSObject(object: budgetObj, values: [spentAmount], keys: ["spentAmount"]);
        
        
        if (spentAmount >= budgetLimit) {
            _ = NotificationsManager.scheduleNotification(date: Date(), message: "You have exceeded your current budget limit!");
        }
        else if (warning <= spentAmount) {
            _ = NotificationsManager.scheduleNotification(date: Date(), message: "Warning, you are aproaching your budget limit!");
        }
    }
    
    static func restartBudget(coreDataManager: CoreDataManager){
        
        guard let budgetObj  = coreDataManager.getLatestNSObject(forEntity: "Budget", latestByKey: "budgetBeginDate") else {
            return
        }
        
        let values = [Date(), 0] as [Any]
        let keys = ["budgetBeginDate", "spentAmount"]
        
        _ = coreDataManager.updateNSObject(object: budgetObj, values: values, keys: keys)
    }
    
    static func didRestart(coreDataManager: CoreDataManager) -> Bool {
        guard let budgetNS = coreDataManager.getLatestNSObject(forEntity: "Budget", latestByKey: "budgetBeginDate") else{
            print("no budget")
            return false
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let budget = budgetNS as! Budget
        
        let budPlusInterval = Date(timeInterval: Double(getTimeInterval(interval: budget.budgetTimeFrame!)), since: budget.budgetBeginDate!)
        let today = Date()
        
        if formatter.string(from: budPlusInterval).lowercased() == formatter.string(from: today).lowercased() {
            restartBudget(coreDataManager: coreDataManager)
            _ = coreDataManager.updateNSObject(object: budget, values: [today], keys: ["budgetBeginDate"])
            return true
        }
        else{
            return false
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
