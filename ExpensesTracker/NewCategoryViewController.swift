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
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        // Do any additional setup after loading the view.
        pickerView.delegate = self
        pickerView.dataSource = self
        if category == nil{
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
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return CGFloat(50)
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
        
        let isDefault = new ? false : category.isDefault
        
        let values = [nameText.text!, isDefault, switchIE.isOn ? "Expense" : "Income", switchIE.isOn ? iconsE[pickerView.selectedRow(inComponent: 0)] : iconsI[pickerView.selectedRow(inComponent: 0)]] as [Any]
        let keys = ["name", "isDefault", "type", "icon"]
        
        if new {
            _ = core.createAndSaveNSObject(forEntity: "Category", values: values, keys: keys)
        }
        else{
            
            _ = core.updateNSObject(object: category, values: values, keys: keys)
            
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func change(_ sender: UISwitch) {
        ei = sender.isOn
        pickerView.reloadAllComponents()
    }
    
    @objc func willEnterForeground(){
        print("perform segue 1")
        let coreDataManager = CoreDataManager(inContext: UIApplication.shared.delegate!)
        let config = coreDataManager.getNSObjects(forEntity: "Configuration")![0] as! Configuration
        print("connfig is \(config.authentication)")
        if config.authentication {
            self.performSegue(withIdentifier: "toLogIn", sender: self)
        }
    }
    
}
