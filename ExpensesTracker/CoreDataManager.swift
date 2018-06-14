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
    
    static func createAndSaveNSObject (forEntity entity: String, params: [Any], keyPaths: [String]) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false;
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext;
        let entity = NSEntityDescription.entity(forEntityName: entity, in: managedContext)!;
        let item = NSManagedObject (entity: entity, insertInto: managedContext);
        
        for i in 0..<params.count {
            item.setValue(params[i], forKeyPath: keyPaths[i]);
        }
        
        do {
            try managedContext.save();
        } catch let error as NSError {
            print ("Could not save data for entity \(entity).\n\(error), \(error.userInfo)");
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
        
        do {
            let data = try managedContext.fetch(fetchRequest);
            return data[0];
        } catch {
            print ("Could find latest entity of type: \(entity)");
        }
        return nil;
        
    }
    
    static func getNSObjects(forEntity entity: String) -> [NSManagedObject]? {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext;
        let fetchRequest = NSFetchRequest<NSManagedObject> (entityName: entity)
        
        do {
            let data = try managedContext.fetch(fetchRequest);
            return data;
        } catch {
            print ("Could not retrieve data from entity: \(entity)");
        }
        return nil;
    }
    
}
