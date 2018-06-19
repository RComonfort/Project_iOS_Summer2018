//
//  ConfigurationTableViewController.swift
//  ExpensesTracker
//
//  Created by Comonfort on 6/8/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit

class ConfigurationTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

    // MARK: - Table view data source

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
                    cell.segueToTrigger = "BudgetConfigurationSegue";
                    cell.titleLabel.text = "Budget Configuration";
                    return cell;
                case 6:
                    cell.segueToTrigger = "RecurrentTransactionsSegue";
                    cell.titleLabel.text = "Manage Recurrent Income & Expenses";
                    return cell;
                default: //case 7
                    cell.segueToTrigger = "CategoryConfigurationSegue";
                    cell.titleLabel.text = "Manage Categories";
                    return cell;
            }
            
        } //Otherwise if it is a switch configuration
        else if (index == 1 || index == 2 || index == 3 || index == 4 || index == 5) {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchTableViewCell", for: indexPath) as! SwitchTableViewCell;
            
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
                    cell.titleLabel.text = "    Recurrent Income/Expense Charged";
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
