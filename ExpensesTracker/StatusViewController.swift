//
//  ViewController.swift
//  ExpensesTracker
//
//  Created by Comonfort on 6/5/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit

class StatusViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onAddIncomeExpense(_ sender: UIButton) {
        
        //If the user wants to add an income
        if (sender.tag == 0)
        {
            
        } //Else if the user wants to add an expense
        else if (sender.tag == 1)
        {
            
        }
        else {
            fatalError("Not a valid sender");
        }
        
        performSegue(withIdentifier: "IncomeExpenseSegue", sender: self)
        
    }
    

}

