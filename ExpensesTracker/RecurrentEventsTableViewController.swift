//
//  RecurrentEventsTableViewController.swift
//  ExpensesTracker
//
//  Created by Alumno on 25/06/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit

class RecurrentEventsTableViewController: UITableViewController {

    var allRecurrents: [RecTransaction]?
    var coreDataManager: CoreDataManager?
    var incomeRecurrents: [RecTransaction]?
    var expenseRecurrents: [RecTransaction]?
    var toUpdate: RecTransaction?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coreDataManager = CoreDataManager(inContext: UIApplication.shared.delegate!)
        rechargeData()
    }

    func getAllRecurrents(){
        let rec = coreDataManager?.getNSObjects(forEntity: "RecTransaction")
        if rec == nil {
            allRecurrents = []
        }
        else {
            if rec!.isEmpty{
                allRecurrents = []
            }
            else{
                allRecurrents = rec as? [RecTransaction]
            }
        }

    }
    
    func setIE(){
        incomeRecurrents = []
        expenseRecurrents = []
        for i in allRecurrents!{
            if i.type?.lowercased() == "expense" {
                incomeRecurrents?.append(i)
            }
            else{
                expenseRecurrents?.append(i)
            }
        }
    }
    
    func rechargeData(){
        getAllRecurrents()
        setIE()
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return (incomeRecurrents?.count)!
        }
        else{
            return (expenseRecurrents?.count)!
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
          return "Income recurrent events"
        }
        else{
            return "Expense recurrent events"
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecurrentEventTableViewCell", for: indexPath) as! RecurrentEventTableViewCell
        var event: RecTransaction!
        
        if indexPath.section == 0{
            event = incomeRecurrents![indexPath.row]
        }
        else{
            event = expenseRecurrents![indexPath.row]
        }
        
        cell.amountLabel.text = "\(event.amount)"
        cell.categoryImage.image = UIImage(named: (event.category?.icon)!)
        cell.categoryNameLabel.text = (event.category?.name)!
        cell.descriptionLabel.text = event.descriptionText
        
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var event: RecTransaction!
            if indexPath.section == 0{
                event = incomeRecurrents![indexPath.row]
            }
            else{
                event = expenseRecurrents![indexPath.row]
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            coreDataManager?.deleteNSObject(object: event)
            rechargeData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            toUpdate = incomeRecurrents?[indexPath.row]
        }
        else{
            toUpdate = expenseRecurrents?[indexPath.row]
        }
        performSegue(withIdentifier: "toUpdateRecurrent", sender: self)
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewCategory" {
            
            (segue.destination as! RecurrentViewController).recurrent = toUpdate!
            
        }
    }

}
