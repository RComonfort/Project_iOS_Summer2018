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
    
    var optionToManage: String?;
    
    @IBAction func onSwitchValueChanged(_ sender: Any) {
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
