//
//  CoreDataManager.swift
//  ExpensesTracker
//
//  Created by Comonfort on 6/13/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    
    static func createAndSaveNSObject (forEntity entity: String, values: [Any], keys: [String]) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false;
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext;
        let entity = NSEntityDescription.entity(forEntityName: entity, in: managedContext)!;
        let item = NSManagedObject (entity: entity, insertInto: managedContext);
        
        for i in 0..<values.count {
            item.setValue(values[i], forKeyPath: keys[i]);
        }
        
        do {
            try managedContext.save();
        } catch let error as NSError {
            print ("Could not save data for entity \(entity).\n\(error), \(error.userInfo)");
            return false;
        }
        
        return true;
    }
    
    static func updateNSObject (object: NSManagedObject, values: [Any], keys: [String]) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false;
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext;
        
        for i in 0..<values.count {
            object.setValue(values[i], forKey: keys[i])
        }
        
        do {
            try managedContext.save();
        } catch let error as NSError {
            print ("Could not update data for object \(object).\n\(error), \(error.userInfo)");
            return false;
        }
        
        return true;
    }
    
    static func getLatestNSObject (forEntity entity: String, latestByKey sortKey: String) -> NSManagedObject? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext;
        let fetchRequest = NSFetchRequest<NSManagedObject> (entityName: entity);
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: sortKey , ascending: false)];
        fetchRequest.fetchLimit = 1;
        //fetchRequest.predicate = NSPredicate(format: "age = %@", "12")
        
        do {
            let data = try managedContext.fetch(fetchRequest);
            if (data.count > 0)
            {
                print ("Returning the latest \(entity) object by its key \(sortKey).")
                return data[0];
            } else {
                return nil;
            }
        } catch {
            print ("Could find latest entity of type: \(entity)");
        }
        return nil;
        
    }
    
    static func findCategory(ofType type: String, withName name: String) -> Category? {
        let objects = getNSObjects(forEntity: "Category");
        
        if (objects == nil || objects?.count == 0)
        {
            print ("Could not find category of type \(type) and name \(name).");
            return nil;
        }
        
        for i in 0..<objects!.count {
            if (objects![i].value(forKey: "type") as! String == type && objects![i].value(forKey: "type") as! String == name){
                return objects![i] as? Category;
            }
        }
        
        print ("Could not find category of type \(type) and name \(name).");
        return nil;
        
    }
    
    static func getNSObjects(forEntity entity: String) -> [NSManagedObject]? {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil;
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext;
        let fetchRequest = NSFetchRequest<NSManagedObject> (entityName: entity);
        
        do {
            let data = try managedContext.fetch(fetchRequest);
            
            if (data.count == 0)
            {
                return nil
            }
            print ("Returning \(entity) objects.");
            return data;
        } catch {
            print ("Could not retrieve data from entity: \(entity)");
        }
        return nil;
    }
    
    static func createAndSaveTransaction (id: UUID, amount: Double, date: Date, description: String, type: String, isRecurrent: Bool, recurrencyBeginDate: Date, recurrencyInterval: String, categoryType: String, categoryName: String) -> Bool {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false;
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext;
        
        let category = findCategory(ofType: categoryType, withName: categoryName);
        
        if (category == nil){
            return false;
        }
        
        let newTransaction = Transaction(context: managedContext);
        newTransaction.id = id;
        newTransaction.amount = amount;
        newTransaction.date = date;
        newTransaction.descriptionText = description;
        newTransaction.type = type;
        newTransaction.isRecurrent = isRecurrent;
        newTransaction.recurrentBeginDate = recurrencyBeginDate;
        newTransaction.recurrentInterval = recurrencyInterval;
        newTransaction.category = category;
        
        do {
            try managedContext.save();
        } catch let error as NSError {
            print ("Could not save transaction. \(error): \(error.localizedDescription)");
            return false;
        }
        
        return true;
    }
}
