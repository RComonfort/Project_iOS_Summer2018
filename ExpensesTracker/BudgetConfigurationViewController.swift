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
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
            
            _ = coreDataManager!.updateNSObject(object: budget!, values: [limit, warningAmount, timeFrame, beginDate], keys: ["limit", "limitWarningAmount", "budgetTimeFrame", "budgetBeginDate"]);
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

}
