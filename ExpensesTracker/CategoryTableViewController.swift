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
    var coreDataManager: CoreDataManager?
    var category: Category!
    override func viewDidLoad() {
        super.viewDidLoad()
        coreDataManager = CoreDataManager(inContext: UIApplication.shared.delegate!)
        if getCategories(){
            tableView.reloadData()
        }
        else{
            categories = []
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryTableViewCell
        cell.categoryName.text = categories[indexPath.row].name
        cell.categoryIcon.image = UIImage(named: categories[indexPath.row].icon!)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        category = categories[indexPath.row]
        performSegue(withIdentifier: "toNewCategory", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewCategory" {
            (segue.destination as! NewCategoryViewController).category = category
            
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            //let category = categories[indexPath.row]
            
        }
    }
    
}
