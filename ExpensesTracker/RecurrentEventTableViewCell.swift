//
//  RecurrentEventTableViewCell.swift
//  ExpensesTracker
//
//  Created by Alumno on 25/06/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit

class RecurrentEventTableViewCell: UITableViewCell {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    @IBOutlet weak var categoryImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
