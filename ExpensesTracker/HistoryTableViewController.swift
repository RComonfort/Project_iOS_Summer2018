//
//  HistoryTableViewController.swift
//  ExpensesTracker
//
//  Created by Comonfort on 6/8/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {

    var transactions: [Transaction] = [];
    var coreDataManager: CoreDataManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        coreDataManager = CoreDataManager(inContext: UIApplication.shared.delegate!);
        
        let objects = coreDataManager!.getNSObjects(forEntity: "Transaction")
        if (objects != nil && (objects?.count)! > 0){
            transactions = objects as! [Transaction];
        }
        
        
        tableView.reloadData();
        
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = UITableViewAutomaticDimension;
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count;
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as? TransactionTableViewCell else {
            fatalError("The dequeued cell is not an instance of TransactionTableViewCell.")
        };

        let category = transactions[indexPath.row].category;
        
        print("Cat name: \(category?.name), img: \(category?.icon)");
        
        cell.amountLabel.text = String(transactions[indexPath.row].amount);
        cell.descriptionLabel.text = transactions[indexPath.row].descriptionText;
        cell.dateLabel.text = "\(transactions[indexPath.row].date!)";
        cell.categoryNameLabel.text = category?.name;
        cell.categoryImage.image = UIImage(contentsOfFile: (category?.icon)!);
        
        if (transactions[indexPath.row].isRecurrent) {
            cell.recurrentIconImage.image = #imageLiteral(resourceName: "recurrent");
        }
        else {
            cell.recurrentIconImage.isHidden = true;
        }
        
        print("Adding to history TVC: \(cell.categoryNameLabel)");
        
        return cell
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
