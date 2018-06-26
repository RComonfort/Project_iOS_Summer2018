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
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        // Do any additional setup after loading the view.
        if transaction == nil {
            imageView.isHidden = true
            categoryType.isHidden = true
            transactionAmount.isHidden = true
            transactionDescription.text = "Whops, it seems like this transaction doesn't exists"
            transactionDate.isHidden = true
        }
        else{
            let custom = CustomFormatter()
            imageView.image = UIImage(named: (transaction.category?.icon)!)
            categoryType.text = transaction.category?.name
            transactionAmount.text = custom.formatCurrency(amount: transaction.amount)
            if transaction.type?.lowercased() == "expense" {
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
