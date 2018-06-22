//
//  ViewTransactionViewController.swift
//  ExpensesTracker
//
//  Created by Alumno on 20/06/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit

class ViewTransactionViewController: UIViewController {

    var transaction: Transaction!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var categoryType: UILabel!
    @IBOutlet weak var transactionAmount: UILabel!
    @IBOutlet weak var transactionDescription: UILabel!
    @IBOutlet weak var transactionDate: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if transaction == nil {
            imageView.isHidden = true
            categoryType.isHidden = true
            transactionAmount.isHidden = true
            transactionDescription.text = "Whops, it seems like this transaction doesn't exists"
            transactionDate.isHidden = true
        }
        else{
            imageView.image = UIImage(named: (transaction.category?.icon)!)
            categoryType.text = transaction.category?.name
            transactionAmount.text = "\(transaction.amount)"
            if transaction.amount < 0.0 {
                transactionAmount.textColor = .red
            }
            else{
                transactionAmount.textColor = .green
            }
            transactionDescription.text = transaction.descriptionText
            let formater = DateFormatter()
            formater.dateFormat = "dd-MM-yyyy"
            transactionDate.text = formater.string(from: transaction.date!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}