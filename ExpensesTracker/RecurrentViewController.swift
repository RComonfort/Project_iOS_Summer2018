//
//  RecurrentViewController.swift
//  ExpensesTracker
//
//  Created by Alumno on 25/06/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit

class RecurrentViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {


    var recurrent: RecTransaction!
    
    @IBOutlet weak var amountText: UITextField!
    @IBOutlet weak var descriptionText: UITextField!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var intervalPicker: UIPickerView!
    @IBOutlet weak var beginPickerView: UIDatePicker!
    
    var categories: [String]!
    var intervals: [String]!
    var coreDataManager: CoreDataManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coreDataManager = CoreDataManager(inContext: UIApplication.shared.delegate!)
        
        
        if recurrent.type?.lowercased() == "expense" {
            categories = DefaultData.getExpenseCategories()
        }
        else{
            categories = DefaultData.getIncomeCategories()
        }
        intervals = DefaultData.getTimeIntervals()
        
        
        categoryPicker.delegate = self
        intervalPicker.delegate = self
        categoryPicker.dataSource = self
        intervalPicker.dataSource = self
        beginPickerView.minimumDate = Date()
        
        categoryPicker.reloadAllComponents()
        intervalPicker.reloadAllComponents()
        putData()
    }
    
    func putData() {
        amountText.text = "\(recurrent.amount)"
        if recurrent.descriptionText != nil && !recurrent.descriptionText!.isEmpty {
            descriptionText.text = recurrent.descriptionText
        }
        for i in 0..<categories.count{
            if categories[i] == recurrent.category?.icon{
                categoryPicker.selectRow(i, inComponent: 0, animated: false)
            }
        }
        for i in 0..<intervals.count{
            if intervals[i] == recurrent.recurrentInterval{
                intervalPicker.selectRow(i, inComponent: 0, animated: false)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 0{
            return 1
        }
        else{
            if pickerView.tag == 2{
                return 1
            }
            else {
                return 0
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0{
            return categories.count
        }
        else{
            if pickerView.tag == 2{
                return intervals.count
            }
            else {
                return 0
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 2{
            return intervals[row]
        }
        else{
            if pickerView.tag == 0 {
                return categories[row]
            }
            else{
                return ""
            }
        }
    }

    @IBAction func exit(_ sender: UIBarButtonItem) {
        goToPreviousScreen()
    }
    
    @IBAction func save(_ sender: Any) {
        if (amountText.text?.isEmpty)!{
            alertUser(title: "Empty amount", message: "Please insert an amount")
            return
        }
        if !checkAmount(amount: amountText.text!){
            alertUser(title: "Invalid amount", message: "Please enter a real number bigger than 0")
            return
        }
        let values = [Double(amountText.text!) as Any, descriptionText.text! as Any, beginPickerView.date as Any, intervals[intervalPicker.selectedRow(inComponent: 0)], coreDataManager?.findCategory(ofType: recurrent.type!, withName: categories[categoryPicker.selectedRow(inComponent: 0)]) as Any]
        let keys = ["amount", "descriptionText", "recurrentBeginDate", "recurrentInterval", "category"]
        
        
        _ = coreDataManager?.updateNSObject(object: recurrent, values: values, keys: keys)
        
        goToPreviousScreen()
    }
    
    func checkAmount(amount: String) -> Bool{
        if let amountDouble = Double(amount){
            print("double")
            if amountDouble > 0{
                print("bigger")
                return true
            }
            else{
                return false
            }
        }
        else{
            return false
        }
    }
    
    func alertUser(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: false)
    }
    
    func goToPreviousScreen() {
        if (navigationController != nil) {
            navigationController?.popViewController(animated: true);
        }
        else {
            fatalError("Recurrent VC has no navigation controller!");
        }
        
    }
    
}
