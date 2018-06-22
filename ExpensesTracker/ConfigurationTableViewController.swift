//
//  ConfigurationTableViewController.swift
//  ExpensesTracker
//
//  Created by Comonfort on 6/8/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit

class ConfigurationTableViewController: UITableViewController, InteractiveTableViewCellDelegate {
    
    var coreDataManager: CoreDataManager?;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        coreDataManager = CoreDataManager(inContext: UIApplication.shared.delegate!);
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        tableView.reloadData();
        
        tableView.rowHeight = 70;
        tableView.estimatedRowHeight = 70;
    }

    // MARK: - Table view data source and delegate functions

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 8;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.row;
        
        //If the row is supposed to be a detail configuration cell
        if (index == 0 || index == 6 || index == 7)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as! DetailTableViewCell;
            
            switch (index) {
                case 0:
                    cell.titleLabel.text = "Budget Configuration";
                    return cell;
                case 6:
                    cell.titleLabel.text = "Manage Recurrent Income & Expenses";
                    return cell;
                default: //case 7
                    cell.titleLabel.text = "Manage Categories";
                    return cell;
            }
            
        } //Otherwise if it is a switch configuration
        else if (index == 1 || index == 2 || index == 3 || index == 4 || index == 5) {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchTableViewCell", for: indexPath) as! SwitchTableViewCell;
            
            //Each switch cell will manage its setting when activated
            switch (index) {
                case 1:
                    cell.titleLabel.text = "Ask for authentication";
                    cell.optionToManage = "Authentication";
                    return cell;
                case 2:
                    cell.titleLabel.text = "Notifications";
                    cell.optionToManage = "Notifications";
                    return cell;
                case 3:
                    cell.titleLabel.text = "    Budget";
                    cell.optionToManage = "Budget";
                    return cell;
                case 4:
                    cell.titleLabel.text = "    Recurrent Charge Done";
                    cell.optionToManage = "Recurrent";
                    return cell;
                default: //case 5
                    cell.titleLabel.text = "    Squander Locations";
                    cell.optionToManage = "Squander";
                    return cell;
            }
        }
        else {
            fatalError("Unknow index in table view cell");
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row;
        
        if (index == 0) {
            performSegue(withIdentifier: "BudgetConfigurationSegue", sender: self);
        } else if (index == 6) {
            performSegue(withIdentifier: "RecurrentTransactionsSegue", sender: self);
        } else if (index == 7) {
            performSegue(withIdentifier: "CategoryConfigurationSegue", sender: self);
        }
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    //MARK: - Interactive Cell Delegate functions
    
    func didInteract(withCell cell: UITableViewCell, cellForRowAt rowIndex: Int) {
        
        //If the notification configuration called this functions
        if (rowIndex == 2) {
            //Enable or disable all switches under it
            
            let switchCell = cell as? SwitchTableViewCell;
            
            let changeToOn = (switchCell?.switchView.isOn)!
            
            for i in 3...5 {
                let currentCell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? SwitchTableViewCell;
             
                currentCell?.changeInteractivity(to: changeToOn);
            }
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "BudgetConfigurationSegue") {
            let destinationVC = segue.destination as! BudgetConfigurationViewController;
        
            let budgets = coreDataManager?.getNSObjects(forEntity: "Budget");
            
            if (budgets != nil && (budgets?.count)! > 0) {
                destinationVC.budget = budgets?[0] as! Budget;
            }
        }
        else if (segue.identifier == "RecurrentTransactionsSegue") {
            let destinationVC = segue.destination;
        }
        else if (segue.identifier == "CategoryConfigurationSegue") {
            let destinationVC = segue.destination;
        }
    }

}
