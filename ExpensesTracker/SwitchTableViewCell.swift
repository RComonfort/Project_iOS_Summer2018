//
//  SwitchTableViewCell.swift
//  ExpensesTracker
//
//  Created by Comonfort on 6/18/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit

enum ESettingStrings: String {
    case Authentication = "authentication"
    case BudgetNotification = "budget"
    case Notifications = "notifications"
    case RecurrentNotification = "recurrent"
    case SquanderNotification = "squander"
}

class SwitchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchView: UISwitch!
    
    var cellDelegate: InteractiveTableViewCellDelegate?
    
    var settingToManage: ESettingStrings?;
    var currentIndexInTable: Int?;
    var lastSwitchValue: Bool = false;
    //var isSettingAvailable: Bool = true;
    //var unavailableSettingMessage: String?;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onSwitchValueChanged(_ sender: UISwitch) {
        
        //Do not let
        /*if (switch.isOn && !isSettingAvailable) {
            
        } */
        
        //call delegate to inform the switch was pressed
        cellDelegate!.didInteract(withCell: self, cellForRowAt: currentIndexInTable!)
    }
    
    
    //Enables or disables interactivity on the content view
    func changeInteractivity(to value: Bool) {
        
        //If we have to deactivate the view, turn it off
        if (!value) {
            
            //save last switch value
            lastSwitchValue = switchView.isOn;
            
            switchView.setOn(false, animated: false);
            
            titleLabel.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5);
            
        }
        else { //if we activate it restore its value
            titleLabel.textColor = .black;
            
            switchView.setOn(lastSwitchValue, animated: false);
        }
        
        switchView.isEnabled = value;
    }
}

//Protocol to pass back information to the table view controller managing this cell
protocol InteractiveTableViewCellDelegate{
    func didInteract(withCell cell: UITableViewCell, cellForRowAt rowIndex: Int)
}
