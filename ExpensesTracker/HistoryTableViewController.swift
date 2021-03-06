//
//  HistoryTableViewController.swift
//  ExpensesTracker
//
//  Created by Comonfort on 6/8/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {

    let INCOME_TEXT_COLOR = UIColor (red: 0, green: 104/255.0, blue: 28/255.0, alpha: 1);
    let EXPENSE_TEXT_COLOR = UIColor (red: 148/255, green: 17/255, blue: 0, alpha: 1);
    
    var transactions: [Transaction] = [];
    var coreDataManager: CoreDataManager?;
    var selectedIndex: Int!;
    
    //MARK: - VC Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        coreDataManager = CoreDataManager(inContext: UIApplication.shared.delegate!);
        
        let objects = coreDataManager!.getNSObjects(forEntity: "Transaction")
        if (objects != nil && (objects?.count)! > 0){
            transactions = objects as! [Transaction];
        }
        
        tableView.reloadData();
        
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    }

    // MARK: - Table view data source and delegate

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
        
        print("Category #\(indexPath.row) name: \(String(describing: category?.name)), image Name: \(String(describing: category?.icon))");
        
        let customFormatter = CustomFormatter();
        
        cell.amountLabel.text = customFormatter.formatCurrency(amount: transactions[indexPath.row].amount);
        cell.descriptionLabel.text = transactions[indexPath.row].descriptionText == "" ? "No description..." : transactions[indexPath.row].descriptionText;
        cell.dateLabel.text = customFormatter.formatDate(date: transactions[indexPath.row].date!);
        cell.categoryNameLabel.text = category?.name;
        cell.categoryImage.image = UIImage(named: (category?.icon)!);
        
        if (transactions[indexPath.row].isAddedByRecurrent) {
            cell.recurrentIconImage.image = #imageLiteral(resourceName: "recurrent");
        }
        else {
            cell.recurrentIconImage.isHidden = true;
        }
        
        cell.amountLabel.textColor = category?.type == "Expense" ? EXPENSE_TEXT_COLOR : INCOME_TEXT_COLOR;
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndex = indexPath.row;
        performSegue(withIdentifier: "ViewTransactionSegue", sender: self);
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


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let transactionVC = segue.destination as? ViewTransactionViewController;
        
        transactionVC?.transaction = transactions[selectedIndex];
    }

    @objc func willEnterForeground(){
        print("perform segue 1")
        let config = coreDataManager?.getNSObjects(forEntity: "Configuration")![0] as! Configuration
        print("connfig is \(config.authentication)")
        if config.authentication {
            self.performSegue(withIdentifier: "toLogIn", sender: self)
        }
    }
    
}
