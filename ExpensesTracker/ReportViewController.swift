//
//  ReportViewController.swift
//  ExpensesTracker
//
//  Created by Alumno on 15/06/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit
import Charts

class ReportViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var percentage: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    let amount = ["Total", "Budget"]
    var timeInterval = DefaultData.getTimeIntervals()
    var labels = ["Income", "Expenses"]
    var values = [0.0, 0.0]
    @IBOutlet weak var chartView: PieChartView!
    var type: String!
    
    
    var coreDataManager: CoreDataManager?
    
    
    
    var budgetLimitCore: Double!
    var budgetLimitWarningCore: Double!
    var budgetUsedCore: Double!
    var timeIntervalIntCore: Int!
    var balanceCore: Double!
    var transactions: [Transaction]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pickerView.delegate = self
        pickerView.dataSource = self
        coreDataManager = CoreDataManager(inContext: UIApplication.shared.delegate!)
        startView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startView()
    }
    
    func startView(){
        pickerView.isHidden = true
        chartView.isHidden = true
        if getTotalCore() == false{
            percentage.text = "You have no transactions, go get some money"
        }
        else if getBudgetCore() == false{
            percentage.text = "You have no budget, go set one in configuration"
        }
        else if getAllTransactions() == false {
            percentage.text = "You have no transactions, go get some money"
        }
        else{
            pickerView.isHidden = false
            chartView.isHidden = false
            managePicker(amountIndex: 0, lapseIndex: 0)
        }
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
            if row == 0{
                timeInterval = DefaultData.getTimeIntervals()
            }
            else{
                _ = timeInterval.popLast()
            }
            pickerView.reloadComponent(1)
            managePicker(amountIndex: row, lapseIndex: pickerView.selectedRow(inComponent: 1))
        }
        else{
            managePicker(amountIndex: pickerView.selectedRow(inComponent: 0), lapseIndex: row)
        }
    }
    
    func getBudgetCore() -> Bool{
        
        let budget = coreDataManager?.getLatestNSObject(forEntity: "Budget", latestByKey: "limit")
        
        if budget == nil {
            return false
        }
        
        budgetLimitCore = budget?.value(forKey: "limit") as! Double
        budgetLimitWarningCore = budget?.value(forKey: "limitWarningAmount") as! Double
        budgetUsedCore = budget?.value(forKey: "spentAmount") as! Double
        
        let timeInt = budget?.value(forKey: "budgetTimeFrame") as! String
        
        for i in 0..<timeInterval.count {
            if timeInt == timeInterval[i] {
                timeIntervalIntCore = i
            }
        }
        
        return true
        
    }
    
    func getTotalCore() -> Bool{
        let balance = coreDataManager?.getLatestNSObject(forEntity: "Balance", latestByKey: "balance")
        
        if balance == nil{
            return false
        }
        
        balanceCore = balance?.value(forKey: "balance") as! Double
        return true
    }
    
    func getAllTransactions() -> Bool{
        let t = coreDataManager?.getNSObjects(forEntity: "Transaction")
        if t == nil {
            return false
        }
        else{
            if (t?.isEmpty)! {
                return false
            }
            else{
                 transactions = t as! [Transaction]
                return true
            }
        }
        
    }
    
    func getDateByLapse(lapseIndex: Int) -> Date{
        
        switch lapseIndex {
        case 0:
            return Date.init(timeIntervalSinceNow: 0)
        case 1:
            return Date.init(timeIntervalSinceNow: -604800)
        case 2:
            return Date.init(timeIntervalSinceNow: -604800 * 2)
        case 3:
            return Date.init(timeIntervalSinceNow: -2592000)
        case 4:
            return Date.init(timeIntervalSinceNow: -2592000 * 2)
        case 5:
            return Date.init(timeIntervalSinceNow: -2592000 * 3)
        case 6:
            return Date.init(timeIntervalSinceNow: -31536000 / 2)
        case 7:
            return Date.init(timeIntervalSinceNow: -31536000)
        case 8:
            return Date.init(timeIntervalSince1970: 0)
        default:
            return Date()
        }
    }
    
    func getTransactionsByDate(lapseIndex: Int) -> [Transaction]{
        let transactionByDate = NSMutableArray()
        
        if lapseIndex == 8 {
            return transactions
        }
        
        let lapseDate = getDateByLapse(lapseIndex: lapseIndex)
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        
        for i in transactions{
            if formater.string(from: i.date!) >= formater.string(from: lapseDate){
                transactionByDate.add(i)
            }
        }
        
        
        return transactionByDate as! [Transaction]
    }
    
    func getIEAmount(transactionsByDate: [Transaction], type: String) -> Double{
        var amount = 0.0
        if transactionsByDate.isEmpty {
            return amount
        }
        for i in transactionsByDate {
            if i.type?.lowercased() == type {
                amount += i.amount
            }
        }
        return amount
    }
    
    func managePicker(amountIndex: Int, lapseIndex: Int){
        //let custom = CustomFormatter()
        type = amount[amountIndex]
        if amountIndex == 0 {
            
            labels = ["Income", "Expenses"]
            if lapseIndex == 8{
                percentage.text = "$\(balanceCore!)"//custom.formatCurrency(amount: balanceCore)
                let incomes = getIEAmount(transactionsByDate: transactions, type: "income")
                let expenses = getIEAmount(transactionsByDate: transactions, type: "expense")
                values[0] = incomes
                values[1] = expenses
                
                if balanceCore < 0 {
                    percentage.textColor = .red
                }
                else{
                    percentage.textColor = .green
                }
                
            }
            else{
                let transactionsByDate = getTransactionsByDate(lapseIndex: lapseIndex)
                let expenses = getIEAmount(transactionsByDate: transactionsByDate, type: "expense")
                let incomes = getIEAmount(transactionsByDate: transactionsByDate, type: "income")
                let total = incomes - expenses
                
                percentage.text = "$\(total)"//custom.formatCurrency(amount: total)
                
                values[0] = incomes
                values[1] = expenses
                
                if total < 0{
                    percentage.textColor = .red
                }
                else {
                    percentage.textColor = .green
                }
            }
        }
        else{
            labels = ["Left in budget", "Expenses"]
            if lapseIndex == timeIntervalIntCore {
                var budgetPercentage = 100.00
                if budgetUsedCore >= budgetLimitCore{
                    values[0] = 0
                    values[1] = budgetUsedCore
                    percentage.textColor = .red                }
                else if budgetUsedCore >= budgetLimitWarningCore{
                    values[0] = budgetLimitCore - budgetUsedCore
                    values[1] = budgetUsedCore
                    percentage.textColor = .yellow
                    budgetPercentage = (values[1] / budgetLimitCore) * 100
                }
                else {
                    values[0] = budgetLimitCore - budgetUsedCore
                    values[1] = budgetUsedCore
                    percentage.textColor = .green
                    budgetPercentage = (values[1] / budgetLimitCore) * 100
                }
                percentage.text = "\(budgetPercentage)%"
            }
            else{
                let budgetLimitWarning = getBudgetLimitOfLapse(lapseTo: lapseIndex, lapseIndex: timeIntervalIntCore, budget: budgetLimitWarningCore)
                let budgetLimit = getBudgetLimitOfLapse(lapseTo: lapseIndex, lapseIndex: timeIntervalIntCore, budget: budgetLimitCore)
                let transactionsByDate = getTransactionsByDate(lapseIndex: lapseIndex)
                let budgetUsed = getIEAmount(transactionsByDate: transactionsByDate, type: "expense")
                
                var budgetPercentage = 100.00
                if budgetUsed >= budgetLimit {
                    values[0] = 0
                    values[1] = budgetUsed
                    percentage.textColor = .red
                }
                else if budgetUsed >= budgetLimitWarning {
                    values[0] = budgetLimit - budgetUsed
                    values[1] = budgetUsed
                    percentage.textColor = .yellow
                    budgetPercentage = (values[1] / budgetLimit) * 100
                }
                else{
                    values[0] = budgetLimit - budgetUsed
                    values[1] = budgetUsed
                    percentage.textColor = .green
                    budgetPercentage = (values[1] / budgetLimit) * 100
                }
                percentage.text = "\(budgetPercentage)%"
            }
        }
        
        drawChart()
    }
    
    func getBudgetLimitOfLapse(lapseTo: Int, lapseIndex: Int, budget: Double) -> Double {
        var mult = 1.0
        var div = 1.0
        switch lapseTo {
        case 0:
            mult = 1.0
            break
        case 1:
            mult = 7.0
            break
        case 2:
            mult = 14.0
            break
        case 3:
            mult = 30.0
            break
        case 4:
            mult = 60.0
            break
        case 5:
            mult = 90.0
            break
        case 6:
            mult = 182.0
            break
        case 7:
            mult = 365.0
            break
        default:
            mult = 1.0
        }
        switch lapseIndex {
        case 0:
            div = 1.0
            break
        case 1:
            div = 7.0
            break
        case 2:
            div = 14.0
            break
        case 3:
            div = 30.0
            break
        case 4:
            div = 60.0
            break
        case 5:
            div = 90.0
            break
        case 6:
            div = 182.0
            break
        case 7:
            div = 365.0
            break
        default:
            div = 1.0
        }
        return (budget / div) * mult
    }
    
    func drawChart(){
        var entries = [ChartDataEntry]()
        
        for i in 0..<values.count {
            let value = PieChartDataEntry(value: values[i], label: labels[i])
            entries.append(value)
        }
        
        let dataSet = PieChartDataSet(values: entries, label: type)
        dataSet.colors = [NSUIColor.green, NSUIColor.red]
        let data = PieChartData(dataSet: dataSet)
        chartView.data = data
        chartView.chartDescription?.text = type
        chartView.drawEntryLabelsEnabled = false
        
    }
    
}
