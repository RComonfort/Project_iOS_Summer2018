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
    
    
    //MARK: - VC Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (transactionMode == ETransactionScreenMode.Detail)
        {
            navigationItem.title = transactionTypeToManage == ETransactionType.Income ? "Income Details" : "Expense Details";
        }
        else if (transactionMode == ETransactionScreenMode.Detail) {
            navigationItem.title  = transactionTypeToManage == ETransactionType.Income ? "New Income" : "New Expense";
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
        
    }
    
    //MARK: - Functions
    
    func loadCategories() {
        
    }
    
    func loadIntervals() {
        
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
