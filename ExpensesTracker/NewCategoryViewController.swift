//
//  NewCategoryViewController.swift
//  ExpensesTracker
//
//  Created by Alumno on 20/06/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit

class NewCategoryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{

    var category: Category!
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var switchIE: UISwitch!
    let iconsE = DefaultData.getExpenseImagesNames()
    let iconsI = DefaultData.getIncomeImagesNames()
    var ei = false
    var new = true
    var originalName: String?
    var originalType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        pickerView.delegate = self
        pickerView.dataSource = self
        if category == nil{
            category = Category()
            nameText.accessibilityHint = "Category name"
            switchIE.setOn(false, animated: false)
            ei = false
            pickerView.reloadAllComponents()
            new = true
        }
        else{
            originalName = category.name
            originalType = category.type
            var index = 0
            nameText.text = category.name
            if category.type?.lowercased() == "expense"{
                switchIE.setOn(true, animated: false)
                ei = true
                for i in 0..<iconsE.count {
                    if iconsE[i] == category.icon{
                        index = i
                    }
                }
            }
            else{
                switchIE.setOn(false, animated: false)
                ei = false
                for i in 0..<iconsI.count {
                    if iconsI[i] == category.icon{
                        index = i
                    }
                }

            }
            pickerView.reloadAllComponents()
            pickerView.selectRow(index, inComponent: 0, animated: false)
            new = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if ei{
            return iconsE.count
        }
        else{
            return iconsI.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if ei{
            return UIImageView.init(image: UIImage(named: iconsE[row]))
        }
        else{
            return UIImageView.init(image: UIImage(named: iconsI[row]))
        }
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        if (nameText.text?.isEmpty)! {
            let alert = UIAlertController(title: "Error", message: "You must include a name for the category", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true)
            return
        }
        let core = CoreDataManager(inContext: UIApplication.shared.delegate!)
        category.name = nameText.text
        category.type = switchIE.isOn ? "Expense" : "Income"
        category.icon = switchIE.isOn ? iconsE[pickerView.selectedRow(inComponent: 0)] : iconsI[pickerView.selectedRow(inComponent: 0)]
        if new {
            category.isDefault = false
            let values = [category.name as Any, category.isDefault as Any, category.type as Any, category.icon as Any]
            let keys = ["name", "isDefault", "type", "icon"]
            _ = core.createAndSaveNSObject(forEntity: "Category", values: values, keys: keys)
        }
        else{
            let uneditedCategory = core.findCategory(ofType: originalType!, withName: originalName!)
            let values = [category.name as Any, category.isDefault as Any, category.type as Any, category.icon as Any]
            let keys = ["name", "isDefault", "type", "icon"]
            _ = core.updateNSObject(object: uneditedCategory!, values: values, keys: keys)
            
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
    
}
