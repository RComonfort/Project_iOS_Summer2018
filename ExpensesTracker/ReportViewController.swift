//
//  ReportViewController.swift
//  ExpensesTracker
//
//  Created by Alumno on 15/06/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var percentage: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    let amount = ["Total", "Budget"]
    let timeInterval = DefaultData.getTimeIntervals()
    
    var coreDataManager: CoreDataManager?
    var budgetLimit: Float!
    var budgetLimitWarning: Float!
    var budgetPercentage: Float!
    var budgetUsed: Float!
    var timeIntervalInt: Int!
    var totalIncome: Float!
    var totalExpense: Float!
    var balance: Float!
    
    
    var budgetLimitCore: Float!
    var budgetLimitWarningCore: Float!
    var budgetUsedCore: Float!
    var timeIntervalIntCore: Int!
    var balanceCore: Float!
    var transactions: [Transaction]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pickerView.delegate = self
        pickerView.dataSource = self
        coreDataManager = CoreDataManager(inContext: UIApplication.shared.delegate!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return amount.count
        }
        else{
            return timeInterval.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            return amount[row]
        }
        else{
            return timeInterval[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{
            
        }
        else{
            
        }
    }
    
    func getBudgetCore(){
        let budget = coreDataManager?.getLatestNSObject(forEntity: "Budget", latestByKey: "limit")
        budgetLimitCore = budget?.value(forKey: "limit") as! Float
        budgetLimitWarningCore = budget?.value(forKey: "limitWarningAmount") as! Float
        budgetUsedCore = budget?.value(forKey: "spentAmount") as! Float
        
        let timeInt = budget?.value(forKey: "budgetTimeFrame") as! String
        
        for i in 0..<timeInterval.count {
            if timeInt == timeInterval[i] {
                timeIntervalIntCore = i
            }
        }
        
        
        
    }
    
    func getTotalCore(){
        let balance = coreDataManager?.getLatestNSObject(forEntity: "Balance", latestByKey: "balance")
        balanceCore = balance?.value(forKey: "balance") as! Float
    }
    
    func getAllTransactions(){
        transactions = coreDataManager?.getNSObjects(forEntity: "Transaction") as! [Transaction]
    }
    
    func getNsDate(intervalIndex: Int) -> Date{
        if intervalIndex == 0{
            return Date()
        }
        else {
            return Date()
        }
    }
    
}
