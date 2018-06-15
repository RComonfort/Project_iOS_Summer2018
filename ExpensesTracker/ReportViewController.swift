//
//  ReportViewController.swift
//  ExpensesTracker
//
//  Created by Alumno on 15/06/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var percentage: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    let amount = ["Total", "Budget"]
    let timeInterval = DefaultData.getTimeIntervals()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pickerView.delegate = self
        pickerView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return amount.count
        }
        else{
            return timeInterval.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            return amount[row]
        }
        else{
            return timeInterval[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{
            
        }
        else{
            
        }
    }
    
    func getBudgetInfo(timeIntervalIndex: Int){
        
    }
    
    func getTotalInfo(timeIntervalIndex: Int){
        
    }
    
    
}
