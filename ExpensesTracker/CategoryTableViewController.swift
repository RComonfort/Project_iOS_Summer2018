//
//  TableViewController.swift
//  ExpensesTracker
//
//  Created by Alumno on 20/06/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {

    var categories : [Category]!
    var incomeCategories = [Category]()
    var expenseCategories = [Category]()
    var coreDataManager: CoreDataManager?
    var category: Category!
    var new = false
    override func viewDidLoad() {
        super.viewDidLoad()
        coreDataManager = CoreDataManager(inContext: UIApplication.shared.delegate!)
        loadData()
    }
    
    func loadData() {
        if getCategories(){
            tableView.reloadData()
        }
        else{
            categories = []
            incomeCategories = []
            expenseCategories = []
            tableView.reloadData()
        }
    }

    func getCategories() -> Bool{
        categories = coreDataManager?.getNSObjects(forEntity: "Category") as! [Category]
        if categories == nil{
            
            return false
        }
        else{
            if categories.isEmpty{
                return false
            }
            else{
                for i in categories {
                    if i.type?.lowercased() == "expense"{
                        expenseCategories.append(i)
                    }
                    else{
                        incomeCategories.append(i)
                    }
                }
                return true
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return ["Income Categories", "Expense Cateogries"]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return incomeCategories.count
        }
        else{
            return expenseCategories.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryTableViewCell
        cell.categoryName.text = categories[indexPath.row].name
        cell.categoryIcon.image = UIImage(named: categories[indexPath.row].icon!)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        new = false
        category = categories[indexPath.row]
        performSegue(withIdentifier: "toNewCategory", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewCategory" {
            if new{
                (segue.destination as! NewCategoryViewController).category = nil
            }
            else{
                (segue.destination as! NewCategoryViewController).category = category
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let categoryToDelete = categories[indexPath.row]
            coreDataManager?.deleteNSObject(object: categoryToDelete)
            loadData()
        }
    }
    
    @IBAction func newCategory(_ sender: Any) {
        new = true
        performSegue(withIdentifier: "toNewCategory", sender: self)
    }
    
}
