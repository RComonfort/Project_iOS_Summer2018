//
//  DefaultData.swift
//  ExpensesTracker
//
//  Created by Comonfort on 6/14/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit

class DefaultData {
    
    static private let INCOME_CATEGORIES = ["Loan", "Salary", "Allowance", "Sales", "Fortune & Prizes", "Tax Return", "Paid Backs", "Rewards", "Gifts"];
    
    static private let EXPENSE_CATEGORIES = ["Friends & Family", "Food", "Leisure & Hobbies", "Lending", "Work Related", "Transportation", "Services", "Home", "Health", "Charity", "Debt Payments"];
    
    static private let INCOME_IMAGES_NAMES = ["loanImg", "salaryImg", "allowanceImg", "salesImg", "fortuneImg", "taxImg", "paidImg", "rewardsImg", "giftsImg"];
    
    static private let EXPENSE_IMAGES_NAMES = ["friendsImg", "foodImg", "leisureImg", "lendingImg", "workImg", "transportImg", "servicesImg", "homeImg", "healthImg", "charityImg", "debtImages"];
    
    static private let TIME_INTERVALS = ["daily", "weekly", "biweekly", "monthly", "bimonthly", "quarterly", "biannual", "yearly", "indefinitely"];
    
    static func getIncomeCategories () -> [String] {
        return INCOME_CATEGORIES;
    }
    
    static func getExpenseCategories () -> [String] {
        return EXPENSE_CATEGORIES;
    }
    
    static func getIncomeImagesNames() -> [String] {
        return INCOME_IMAGES_NAMES;
    }
    
    static func getExpenseImagesNames() -> [String] {
        return EXPENSE_IMAGES_NAMES;
    }
    
    static func getTimeIntervals() -> [String] {
        return TIME_INTERVALS;
    }
}
