//
//  NumberFormatter.swift
//  ExpensesTracker
//
//  Created by Comonfort on 6/13/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit

class CustomFormatter {
    
    func formatCurrency(amount: Double) -> String{
        
        //Extracts 2 decimals out of the number
        let decimalValue = amount.truncatingRemainder(dividingBy: 1) * 100;
        
        var numbersAsThousands: [String] = [];
        
        var x = Int(amount);
        while (x > 0)
        {
            numbersAsThousands.append("\(x % 1000)");
            x = x / 1000;
        }
        numbersAsThousands.reverse();
        
        var number = "";
        
        if (numbersAsThousands.count > 0)
        {
            for n in numbersAsThousands {
                number.append(n + ",")
            }
            number.remove(at: number.index(before: number.endIndex));
        }
        else {
            number.append("0");
        }
        
        return "$\(number).\(decimalValue)";
    }
    
    func formatDate (date: Date) -> String{
        
        let components = Calendar.current.dateComponents([.day, .month, .year], from: date);
        
        let yearStr = String(describing: components.year);
        
        return "\(components.day!)/\(components.month!)/";
    }
    
}
