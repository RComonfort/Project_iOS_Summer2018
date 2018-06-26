//
//  ViewController.swift
//  ExpensesTracker
//
//  Created by Comonfort on 6/5/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit
import CoreData

enum ETransactionType {
    case Income
    case Expense
}

class StatusViewController: UIViewController {
    
    var transactionTypeToAdd: ETransactionType?;
    var coreDataManager: CoreDataManager?;
    
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var budgetLeftLabel: UILabel!
    
    
    //MARK: - VC Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coreDataManager = CoreDataManager(inContext: UIApplication.shared.delegate!);
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        loadBalanceLabelContent();
        loadBudgetLeftLabelContent();
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! IncomeExpenseViewController;
        
        destinationVC.transactionTypeToManage = transactionTypeToAdd;
    }

    //MARK: - Functions
    
    func loadBudgetLeftLabelContent() {
        //If no budget has been registered, place an empty string
        guard let budgetObj = coreDataManager!.getLatestNSObject(forEntity: "Budget", latestByKey: "budgetBeginDate") else {
            
            budgetLeftLabel.text = "----";
            return;
        }
        let latestLimit = budgetObj.value(forKeyPath: "limit") as! Double;
        let spentAmount = budgetObj.value(forKeyPath: "spentAmount") as! Double;
        
        budgetLeftLabel.text = String(latestLimit - spentAmount);
    }
    
    func loadBalanceLabelContent() {
        //If no balance has been registered, do so
        guard let balanceObjects = coreDataManager!.getNSObjects(forEntity: "Balance") else {
            _ = coreDataManager!.createAndSaveNSObject(forEntity: "Balance", values: [0.0], keys: ["balance"]);
            
            balanceLabel.text = String(0.0);
            return;
        }
        let balance = balanceObjects[0].value(forKeyPath: "balance") as! Double
        
        balanceLabel.text = String(balance);
    }
    
    // MARK: - IBActions
    @IBAction func onAddIncomeExpense(_ sender: UIButton) {
        
        //If the user wants to add an income
        if (sender.tag == 0)
        {
            transactionTypeToAdd = ETransactionType.Income;
        } //Else if the user wants to add an expense
        else if (sender.tag == 1)
        {
            transactionTypeToAdd = ETransactionType.Expense;
        }
        else {
            fatalError("Not a valid sender");
        }
        
        performSegue(withIdentifier: "IncomeExpenseSegue", sender: self);
        
    }
}

