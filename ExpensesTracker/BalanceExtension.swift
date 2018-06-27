//
//  BalanceExtension.swift
//  ExpensesTracker
//
//  Created by Comonfort on 6/27/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit

extension Balance {
    
    static func checkBalanceExistence(coreDataManager: CoreDataManager) {
        
        guard let balanceObjects = coreDataManager.getNSObjects(forEntity: "Balance"), balanceObjects.count > 0 else {
        
            _ = coreDataManager.createAndSaveNSObject(forEntity: "Balance", values: [0.0], keys: ["balance"]);
            return;
        }
    }
    
    static func updateBalanceAmount(amount: Double, coreDataManager: CoreDataManager) {
        
        guard let balanceObjects = coreDataManager.getNSObjects(forEntity: "Balance"), balanceObjects.count > 0 else {
            fatalError("Balance object not yet created!!!");
        }
        
        let balanceObj = balanceObjects[0];
        var balance = balanceObj.value(forKeyPath: "balance") as! Double;
        
        balance += amount;
        
        _ = coreDataManager.updateNSObject(object: balanceObj, values: [balance], keys: ["balance"]);
        
    }
}
