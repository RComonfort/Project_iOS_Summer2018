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
    
    private let delegate: AppDelegate;
    
    init(inContext delegate: UIApplicationDelegate) {
        guard let appDelegate = delegate as? AppDelegate else {
            fatalError("Invalid AppDelegate");
        }
        
        self.delegate = appDelegate;
    }
    
    func createAndSaveNSObject (forEntity entity: String, values: [Any], keys: [String]) -> Bool {
        
        if (values.count != keys.count) {
            fatalError("Incorrect use of method! all values must match to a key and viceversa");
        }
        
        let managedContext = delegate.persistentContainer.viewContext;
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
    
    func updateNSObject (object: NSManagedObject, values: [Any], keys: [String]) -> Bool {
        
        if (values.count != keys.count) {
            fatalError("Incorrect use of method! all values must match to a key and viceversa");
        }
        
        let managedContext = delegate.persistentContainer.viewContext;
        
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
    
    func getLatestNSObject (forEntity entity: String, latestByKey sortKey: String) -> NSManagedObject? {

        let managedContext = delegate.persistentContainer.viewContext;
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
    
    func findCategory(ofType type: String, withName name: String) -> Category? {
        let objects = getNSObjects(forEntity: "Category");
        
        if (objects == nil || objects?.count == 0)
        {
            print ("Could not find category of type \(type) and name \(name).");
            return nil;
        }

        for i in 0..<objects!.count {
            
            if (objects![i].value(forKey: "type") as! String == type && objects![i].value(forKey: "name") as! String == name){
                print("Returning category of type \(objects![i].value(forKey: "type") as! String), and name \(objects![i].value(forKey: "name") as! String)");
                return objects![i] as? Category;
            }
        }
        
        print ("Could not find category of type \(type) and name \(name).");
        return nil;
        
    }
    
    func getNSObjects(forEntity entity: String) -> [NSManagedObject]? {

        
        let managedContext = delegate.persistentContainer.viewContext;
        let fetchRequest = NSFetchRequest<NSManagedObject> (entityName: entity);
        
        do {
            let data = try managedContext.fetch(fetchRequest);
            
            print ("Returning \(data.count) \(entity) objects.");
            
            return data.count > 0 ? data : nil;
            
        } catch {
            print ("Could not retrieve data from entity: \(entity)");
        }
        return nil;
    }
    
    func createEmptyNSObject (ofEntityType entity: String) -> NSManagedObject? {

        let managedContext = delegate.persistentContainer.viewContext;
        let entity = NSEntityDescription.entity(forEntityName: entity, in: managedContext)!;
        return NSManagedObject (entity: entity, insertInto: managedContext);
    }
    
    func deleteNSObject (object: NSManagedObject) {
        let managedContext = delegate.persistentContainer.viewContext
        managedContext.delete(object)
    }
}
