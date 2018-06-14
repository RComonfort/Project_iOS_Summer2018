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

class IncomeExpenseViewController: UIViewController {

    var transactionTypeToManage: ETransactionType?;
    var transactionMode: ETransactionScreenMode?;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (transactionMode == ETransactionScreenMode.Detail)
        {
            navigationItem.title = transactionTypeToManage == ETransactionType.Income ? "Income Details" : "Expense Details";
        }
        else if (transactionMode == ETransactionScreenMode.Detail) {
            navigationItem.title  = transactionTypeToManage == ETransactionType.Income ? "New Income" : "New Expense";
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
