//
//  TransactionTableViewCell.swift
//  ExpensesTracker
//
//  Created by Comonfort on 6/15/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoryImage: UILabel!
    
    @IBOutlet weak var recurrentIconImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
