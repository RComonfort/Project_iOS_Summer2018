//
//  SwitchTableViewCell.swift
//  ExpensesTracker
//
//  Created by Comonfort on 6/18/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchView: UISwitch!
    
    var cellDelegate: InteractiveTableViewCellDelegate?
    
    var optionToManage: String?;
    var currentIndexInTable: Int?;
    var lastSwitchValue: Bool = false;
    
    @IBAction func onSwitchValueChanged(_ sender: Any) {
        
        //call delegate to inform the switch was pressed
        cellDelegate!.didInteract(withCell: self, cellForRowAt: currentIndexInTable!)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //Enables or disables interactivity on the content view
    func changeInteractivity(to value: Bool) {
        
        //If we have to deactivate the view, save the value it had the switch and turn it off
        if (!value) {
            lastSwitchValue = switchView.isOn;
            switchView.setOn(false, animated: false);
            
            titleLabel.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5);
        }
        else { //if we activate it restore its value
            switchView.setOn(lastSwitchValue, animated: false);
            titleLabel.textColor = .black;
        }
        
        switchView.isEnabled = value;
    }
}

//Protocol to pass back information to the table view controller managing this cell
protocol InteractiveTableViewCellDelegate{
    func didInteract(withCell cell: UITableViewCell, cellForRowAt rowIndex: Int)
}
