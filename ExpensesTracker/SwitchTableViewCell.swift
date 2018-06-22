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
    var currentIndexPath: Int?;
    
    @IBAction func onSwitchValueChanged(_ sender: Any) {
        
        
        //call delegate to inform the switch was pressed
        cellDelegate!.didInteract(withCell: self, cellForRowAt: currentIndexPath!)
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
        
        contentView.isUserInteractionEnabled = value;
        contentView.isOpaque = !value;
        switchView.isEnabled = value;
    }

}

//Protocol to pass back information to the table view controller managing this cell
protocol InteractiveTableViewCellDelegate{
    func didInteract(withCell cell: UITableViewCell, cellForRowAt rowIndex: Int)
}
