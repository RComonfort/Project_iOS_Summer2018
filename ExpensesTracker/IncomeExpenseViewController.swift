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

    }
    
    //MARK: - IBActions
    
    @IBAction func onSwitchValueChanged(_ sender: UISwitch)
    {
        if (sender.isOn)
        {
            beginDateWheel.isHidden = false;
            beginDateLabel.isHidden = false;
            intervalDatePicker.isHidden = false;
            intervalLabel.isHidden = false;
            
        } else {
            beginDateWheel.isHidden = true;
            beginDateLabel.isHidden = true;
            intervalDatePicker.isHidden = true;
            intervalLabel.isHidden = true;
        }
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
        
        //A recurrent transaction must be added
        if (switchView.isOn) {
            
            let recurrentInterval = intervalDates[intervalDatePicker.selectedRow(inComponent: 0)];
            let recurrentBeginDate = beginDateWheel.date;
            
            let recTransaction = coreDataManager!.createEmptyNSObject(ofEntityType: "RecTransaction") as! RecTransaction;
            
            _ = coreDataManager!.updateNSObject(object: recTransaction,
                values: [
                    type, id, descriptionText, amount, category, recurrentInterval, recurrentBeginDate
                ], keys: [
                    "type", "id", "descriptionText", "amount", "category", "recurrentInterval", "recurrentBeginDate"
                ]);
            
        } else { //A transaction must be added
            
            let isAddedByRecurrent = false;

            let transaction = coreDataManager!.createEmptyNSObject(ofEntityType: "Transaction") as! Transaction;
            
            _ = coreDataManager!.updateNSObject(object: transaction,
                values: [
                    type, id, descriptionText, amount, date, category, isAddedByRecurrent
                ], keys: [
                    "type", "id", "descriptionText", "amount", "date", "category", "isAddedByRecurrent"
                ]);
        }
        print ("Transaction added succesfully.");
        
        updateBudgetSpenditure(amount);
        updateBalance(amount);

        goToPreviousScreen();
    }
    
    //MARK: - Functions
    
    func updateBudgetSpenditure(_ amount: Double) {
        
        //Only update if on a budget and if the we are managing an expense
        guard let budgetObj = coreDataManager!.getLatestNSObject(forEntity: "Budget", latestByKey: "budgetBeginDate"), transactionTypeToManage == ETransactionType.Expense  else {
            return;
        }
        
        let spentAmount = (budgetObj.value(forKey: "spentAmount") as! Double) + amount;
        
        _ = coreDataManager!.updateNSObject(object: budgetObj, values: [spentAmount], keys: ["spentAmount"]);
    }
    
    func updateBalance(_ amount: Double) {
        guard let balanceObjects = coreDataManager!.getNSObjects(forEntity: "Balance"), balanceObjects.count > 0 else {
            fatalError("Balance object not yet created!!!");
        }
        
        let balanceObj = balanceObjects[0];
        var balance = balanceObj.value(forKeyPath: "balance") as! Double;

    
        if (transactionTypeToManage == ETransactionType.Expense) {
            balance -= amount;
            
        } else {
            balance += amount;
        }
        _ = coreDataManager!.updateNSObject(object: balanceObj, values: [balance], keys: ["balance"]);
        
    }
    
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
    

}
