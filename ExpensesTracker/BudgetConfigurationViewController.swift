//
//  BudgetConfigurationViewController.swift
//  ExpensesTracker
//
//  Created by Comonfort on 6/8/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit

class BudgetConfigurationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var budget: Budget?;
    var timeFrames: [String] = [];
    var coreDataManager: CoreDataManager?;
    
    @IBOutlet weak var budgetLimitTextField: UITextField!
    @IBOutlet weak var budgetWarningAmountTextField: UITextField!
    @IBOutlet weak var budgetTimeFramePicker: UIPickerView!
    @IBOutlet weak var budgetBeginDateWheel: UIDatePicker!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Add target to text fields to validate them
        budgetLimitTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged);
        budgetWarningAmountTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged);
        
        saveButton.isEnabled = false;
        textFieldDidChange(textField: budgetLimitTextField);
        
        timeFrames = DefaultData.getTimeIntervals();
        
        budgetTimeFramePicker.delegate = self;
        budgetTimeFramePicker.dataSource = self;
        budgetTimeFramePicker.reloadComponent(0);
    
        
        //There is a existing budget, fill in its data to the outlets
        if (budget != nil) {
            budgetLimitTextField.text = "\(budget!.limit)";
            budgetWarningAmountTextField.text = "\(budget!.limitWarningAmount)";
            budgetBeginDateWheel.setDate(budget!.budgetBeginDate!, animated: false);
        }
        else {
            //new budgets cannot have a begin date in the past
            budgetBeginDateWheel.minimumDate = Date();
        }
        
        coreDataManager = CoreDataManager(inContext: UIApplication.shared.delegate!);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - IBActions

    @IBAction func cancel(_ sender: Any) {
        goToPreviousScreen();
    }
    
    @IBAction func save(_ sender: Any) {
        
        let limit = Double(budgetLimitTextField.text!)!;
        let warningAmount = Double(budgetWarningAmountTextField.text!)!;
        let timeFrame = timeFrames[budgetTimeFramePicker.selectedRow(inComponent: 0)];
        let beginDate = budgetBeginDateWheel.date;
        let spentAmount = 0.0;
        
        //Save uptes to existing budget
        if (budget != nil) {
            
            _ = coreDataManager!.updateNSObject(object: budget!, values: [limit, warningAmount, timeFrame, beginDate, spentAmount], keys: ["limit", "limitWarningAmount", "budgetTimeFrame", "budgetBeginDate", "spentAmount"]);
        }
        else {
            _ = coreDataManager!.createAndSaveNSObject(forEntity: "Budget", values: [limit, warningAmount, timeFrame, beginDate, spentAmount], keys: ["limit", "limitWarningAmount", "budgetTimeFrame", "budgetBeginDate", "spentAmount"]);
        }
        
        goToPreviousScreen();
    }
    
    //MARK: - UIPicker Delegate Functions
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeFrames.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return timeFrames[row];
    }
    
    // MARK: - Navigation
    
    func goToPreviousScreen() {
        if (navigationController != nil) {
            navigationController?.popViewController(animated: true);
        }
        else {
           fatalError("Budget VC has no navigation controller!");
        }
    }
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    //MARK: - Functions
    
    @objc func textFieldDidChange(textField: UITextField){
        
        if (textField.text != nil  && textField.text! != ""){
            if let num = Double (textField.text!) {
                if (num > 0.0) {
                    
                    //If this is the budget warning text field
                    if (textField == budgetWarningAmountTextField){
                        //Check that it must be less than or equal to the limit budget
                        if let text = budgetLimitTextField.text, let limitNum = Double (text) {
                            if (num <= limitNum) {
                                
                                textField.textColor = .black;
                                budgetLimitTextField.textColor = .black;
                                
                                saveButton.isEnabled = true;
                                return;
                                
                            } else { //If not, mark both textfields as wrong
                                budgetLimitTextField.textColor = .red;
                            }
                        } else {
                            textField.textColor = .black;
                            return;
                        }
                    }
                    else if (textField == budgetLimitTextField){ //if this is the limit budget text field
                        
                        //Check the same. This ensures that both text fields are mutually validating each other
                        if let text = budgetWarningAmountTextField.text, let warningNum = Double (text) {
                            if (warningNum <= num) {
                                
                                textField.textColor = .black;
                                budgetWarningAmountTextField.textColor = .black;
                                
                                saveButton.isEnabled = true;
                                return;
                                
                            } else { //If not, mark both textfields as wrong
                                budgetWarningAmountTextField.textColor = .red;
                            }
                        } else {
                            textField.textColor = .black;
                            return;
                        }
                    }
                    
                }
            }
        }
        
        textField.textColor = .red;
        saveButton.isEnabled = false;
    }

}
