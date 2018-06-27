//
//  IncomeExpenseViewController.swift
//  ExpensesTracker
//
//  Created by Comonfort on 6/8/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit

class IncomeExpenseViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var transactionTypeToManage: ETransactionType?;
    
    var coreDataManager: CoreDataManager?;
    
    var categories: [String] = [];
    var intervalDates: [String] = [];
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var beginDateWheel: UIDatePicker!
    @IBOutlet weak var beginDateLabel: UILabel!
    @IBOutlet weak var intervalDatePicker: UIPickerView!
    @IBOutlet weak var intervalLabel: UILabel!

    @IBOutlet weak var switchView: UISwitch!
    
    //MARK: - VC Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        coreDataManager = CoreDataManager(inContext: UIApplication.shared.delegate!);
        
        navigationItem.title  = transactionTypeToManage == ETransactionType.Income ? "New Income" : "New Expense";
        
        loadCategories();
        loadIntervals();
        
        beginDateWheel.minimumDate = Date();
        
        categoryPicker.dataSource = self;
        categoryPicker.delegate = self;
        
        intervalDatePicker.dataSource = self;
        intervalDatePicker.delegate = self;
        
        amountTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged);
        
        saveButton.isEnabled = false;
        
        switchView.isOn = false;
        updateRecurrentSettingsIBOutlets(setHiddenValueTo: true);
        
    }
    
    //MARK: - IBActions
    
    @IBAction func onSwitchValueChanged(_ sender: UISwitch)
    {
        updateRecurrentSettingsIBOutlets(setHiddenValueTo: !sender.isOn);
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        let type = transactionTypeToManage == ETransactionType.Expense ? "Expense" : "Income";
        let id = UUID();
        let descriptionText = descriptionTextField.text ?? "";
        let amount = Double(amountTextField.text!)!;
        let date = Date();
        
        let categoryName = categories[categoryPicker.selectedRow(inComponent: 0)];
        let categoryType = type;
        let category = coreDataManager!.findCategory(ofType: categoryType, withName: categoryName)!
        
        
        //A  transaction must be added
        if (!switchView.isOn) {
            
            let isAddedByRecurrent = false;
            
            let transaction = coreDataManager!.createEmptyNSObject(ofEntityType: "Transaction") as! Transaction;
            
            transaction.category = category;
            
            _ = coreDataManager!.updateNSObject(object: transaction,
                                                values: [
                                                    type, id, descriptionText, amount, date, isAddedByRecurrent
                ], keys: [
                    "type", "id", "descriptionText", "amount", "date", "isAddedByRecurrent"
                ]);
        
            
            if (transactionTypeToManage == ETransactionType.Expense) {
                Budget.updateBudgetSpenditure(amount, coreDataManager: coreDataManager!);
                Budget.checkBudgetLimit(coreDataManager: coreDataManager!);
            }
            
            let balanceDelta = transactionTypeToManage == ETransactionType.Expense ? -amount : amount;
            
            Balance.updateBalanceAmount(amount: balanceDelta, coreDataManager: coreDataManager!);
            
            print ("Transaction added succesfully.");
            
        } else { //A Recurrent transaction must be added
            
            addTimerIfFirstRecurrent()
            
            let recurrentInterval = intervalDates[intervalDatePicker.selectedRow(inComponent: 0)];
            let recurrentBeginDate = beginDateWheel.date;
            
            let recTransaction = coreDataManager!.createEmptyNSObject(ofEntityType: "RecTransaction") as! RecTransaction;
            
            _ = coreDataManager!.updateNSObject(object: recTransaction,
                                                values: [
                                                    type, id, descriptionText, amount, category, recurrentInterval, recurrentBeginDate
                ], keys: [
                    "type", "id", "descriptionText", "amount", "category", "recurrentInterval", "recurrentBeginDate"
                ]);
            
            print ("RecTransaction added succesfully.");
        }

        goToPreviousScreen();
    }
    
    //MARK: - Functions
    
    func loadCategories() {
        if (transactionTypeToManage == ETransactionType.Expense)
        {
            categories = DefaultData.getExpenseCategories();
        }
        else {
            categories = DefaultData.getIncomeCategories();
        }
        
    }
    
    func loadIntervals() {
        intervalDates = DefaultData.getTimeIntervals();
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        if let num = Double (textField.text!) {
            if num > 0.0 {
                saveButton.isEnabled = true;
                textField.textColor = .black;
                return;
            }
        }
        
        textField.textColor = .red;
        saveButton.isEnabled = false;
    }
    
    func updateRecurrentSettingsIBOutlets(setHiddenValueTo value: Bool) {
        
        beginDateWheel.isHidden = value;
        beginDateLabel.isHidden = value;
        intervalDatePicker.isHidden = value;
        intervalLabel.isHidden = value;
    }
    
    //MARK: - PickerDelegate Functions
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 0) {
            return categories.count;
        }
        else if (pickerView.tag == 1) {
            return intervalDates.count;
        }
        else {
            fatalError("Unkown picker called for number of rows");
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 0) {
            return categories[row];
        }
        else if (pickerView.tag == 1) {
            return intervalDates[row];
        }
        else {
            fatalError("Unkown picker called for title for row");
        }
    }
    
    
    // MARK: - Navigation

    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    //}

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        goToPreviousScreen();
    }
    
    func goToPreviousScreen() {
        if (navigationController != nil) {
            navigationController?.popViewController(animated: true);
        }
        else {
            fatalError("Income/Expense VC has no navigation controller!");
        }

    }
    
    @objc func willEnterForeground(){
        print("perform segue 1")
        let config = coreDataManager?.getNSObjects(forEntity: "Configuration")![0] as! Configuration
        print("connfig is \(config.authentication)")
        if config.authentication {
            self.performSegue(withIdentifier: "toLogIn", sender: self)
        }
    }
    
    func addTimerIfFirstRecurrent(){
        if ((coreDataManager?.getNSObjects(forEntity: "RecTransaction")) == nil){
            print("added timer")
            var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
            components.hour = 2
            components.minute = 0
            components.second = 0
            let date = Calendar.current.date(from: components)
            print(date!)
            let timer = Timer(fireAt: date!, interval: Double(DefaultData.getTimeIntervalsSeconds()[0]), target: self, selector: #selector(runCode), userInfo: nil, repeats: false)
            RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
            return
        } else {
            print("not added")
            return
        }
        
    }
    
    @objc func runCode() {
        print("run code")
        RecTransaction.doRecurrentTransactions(coreDataManager: CoreDataManager(inContext: UIApplication.shared.delegate!))
    }
}
