//
//  IncomeExpenseViewController.swift
//  ExpensesTracker
//
//  Created by Comonfort on 6/8/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit

enum ETransactionScreenMode {
    case Detail
    case Addition
}

class IncomeExpenseViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var transactionTypeToManage: ETransactionType?;
    var transactionMode: ETransactionScreenMode?;
    var dateOfAddition = Date();
    
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

        if (transactionMode == ETransactionScreenMode.Detail)
        {
            navigationItem.title = transactionTypeToManage == ETransactionType.Income ? "Income Details" : "Expense Details";
            
            //TODO: Necessary set up for displaying current info
            
        }
        else if (transactionMode == ETransactionScreenMode.Addition) {
            navigationItem.title  = transactionTypeToManage == ETransactionType.Income ? "New Income" : "New Expense";
            
            dateOfAddition = Date();
        }
        
        loadCategories();
        loadIntervals();
        
        beginDateWheel.minimumDate = Date();
        
        categoryPicker.dataSource = self;
        categoryPicker.delegate = self;
        
        intervalDatePicker.dataSource = self;
        intervalDatePicker.delegate = self;
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
        let description = descriptionTextField.text ?? "";
        let amount = Double(amountTextField.text!)!;
        let date = dateOfAddition;
        
        let isRecurrent = switchView.isOn;
        var recurrentInterval = intervalDates[intervalDates.count - 1];
        var recurrrentBeginDate = Date();
        
        if (isRecurrent) {
            recurrentInterval = intervalDates[intervalDatePicker.selectedRow(inComponent: 0)];
            recurrrentBeginDate = beginDateWheel.date;
        }
        
        let categoryName = categories[categoryPicker.selectedRow(inComponent: 0)];
        
        //TODO: might require refactor to accomodate easy update operations on whole object
        
        let success = CoreDataManager.createAndSaveTransaction(id: id, amount: amount, date: date, description: description, type: type, isRecurrent: isRecurrent, recurrencyBeginDate: recurrrentBeginDate, recurrencyInterval: recurrentInterval, categoryType: type, categoryName: categoryName);
        
        if (success)
        {
            print ("Transaction added succesfully.");
        }
        
        updateBudgetSpenditure(amount);
        updateBalance(amount);

        goToPreviousScreen();
    }
    
    //MARK: - Functions
    
    func updateBudgetSpenditure(_ amount: Double) {
        
    }
    
    func updateBalance(_ amount: Double) {
        guard let balanceObjects = CoreDataManager.getNSObjects(forEntity: "Balance"), balanceObjects.count > 0 else {
            fatalError("Balance object not yet created!!!");
        }
        
        let balanceObj = balanceObjects[0];
        var balance = balanceObj.value(forKeyPath: "balance") as! Double;

        
        //If the screen was loaded to add a new transaction, simply modify the balance directly
        if (transactionMode == ETransactionScreenMode.Addition) {
            if (transactionTypeToManage == ETransactionType.Expense) {
                
                balance -= amount;
                
            } else {
                balance += amount;
            }
        } else { //Else if we are editing a transaction, adjust the delta of the amount
            if (transactionTypeToManage == ETransactionType.Expense) {
                
            } else {
                
            }
        }
        
        CoreDataManager.updateNSObject(object: balanceObj, values: [balance], keys: ["balance"]);
        
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
