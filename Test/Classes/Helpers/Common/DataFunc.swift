//
//  Common.swift
//  Test
//
//  Created by Le Thi An on 12/17/15.
//  Copyright © 2015 Le Thi An. All rights reserved.
//

import Foundation
import UIKit
import CoreData

var DB_NAME:String = "Favorite"

let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

let managedContext = appDelegate.managedObjectContext

class CommonDataFunc {
    
//extension UIViewController {

    class func saveFavoriteData(name:String, artist:String, imageLink:String, wvLink:String, key:Int) {
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        
//        let managedContext = appDelegate.managedObjectContext
        
        
        let entity =  NSEntityDescription.entityForName(DB_NAME, inManagedObjectContext:managedContext)
        
        
        let favorite = NSManagedObject(entity: entity!,insertIntoManagedObjectContext: managedContext)
        
        // add our data
        favorite.setValue(artist, forKey: "author")
        favorite.setValue(name, forKey: "title")
        favorite.setValue(key, forKey: "type")
        favorite.setValue(imageLink , forKey: "imageLink")
        favorite.setValue(wvLink , forKey: "webViewLink")
        
//        print(imageLink)
//        print(wvLink)
//        print("===============")
        
        // we save our entity
        do {
            try managedContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
        appDelegate.saveContext()
    }
    
     class func fetchAllFavoriteData()->[NSManagedObject]{
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        
//        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: DB_NAME)
        var list:[NSManagedObject] = []
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            list = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        print("Count: \(list.count)")
        
        for item in list {
            print(item.valueForKey("author"))
            print(item.valueForKey("title"))
            print(item.valueForKey("imageLink"))
            print(item.valueForKey("webViewLink"))
            print(item.valueForKey("type"))
            print("========================")
        }
        return list
    }
    
    class func fetchDataByAtrr(attr:String, key:String, type: Int)-> [NSManagedObject]{
//        let fetchRequest = NSFetchRequest(entityName: DB_NAME)
//        let predicate = NSPredicate(format: "%@ contains[c] %@",attr, key)
//        print(predicate)
//        
//        fetchRequest.predicate = predicate
        var list:[NSManagedObject] = []
        var results:[NSManagedObject] = []
//        do {
//            let results = try managedContext.executeFetchRequest(fetchRequest)
//            list = results as! [NSManagedObject]
//        } catch let error as NSError {
//            print("Could not fetch \(error), \(error.userInfo)")
//        }
//        print(list.count)
        
        results = fetchFavoriteDataByType(type)
        print(results.count)
        for result in results {
            let title = result.valueForKey(attr) as! String
            let lwr = title.lowercaseString
            print(lwr)
            print(key.lowercaseString)
            if lwr.containsString(key.lowercaseString) {
                list.append(result)
            }
        }
        print(list.count)
        return list
    }
    
    
    
    class func fetchFavoriteDataByType(key:Int)->[NSManagedObject] {
        
        let fetchRequest = NSFetchRequest(entityName: DB_NAME)
        let predicate = NSPredicate(format: "type = %d", key)
        fetchRequest.predicate = predicate
        var list:[NSManagedObject] = []
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            list = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
//        print("Count: \(list.count)")
//
//        for item in list {
//            print(item.valueForKey("author"))
//            print(item.valueForKey("title"))
//            print(item.valueForKey("imageLink"))
//            print(item.valueForKey("webViewLink"))
//            print(item.valueForKey("type"))
//            print("========================")
//        }
        return list
    }
    
    class func deleteAllData()
    {
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: DB_NAME)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.deleteObject(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(DB_NAME) error : \(error) \(error.userInfo)")
        }
    }
    
    class func deleteObjData(data: NSManagedObject) {
        do {
            // remove your object
            
            managedContext.deleteObject(data)
            
            // save your changes
            try managedContext.save()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }        
    }
    
    class func isFavorite(author:String, title:String, imageLink:String, key:Int)->Bool{
        
        let listFavOfType = fetchFavoriteDataByType(key)
        var itemAuthor:String?
        var itemTitle:String?
        var itemLink:String?
        for item in listFavOfType {
            itemAuthor = item.valueForKey("author") as? String
            itemTitle = item.valueForKey("title") as? String
            itemLink = item.valueForKey("imageLink") as? String
            if(author == itemAuthor && title == itemTitle && imageLink == itemLink) {
                return true
            }
        }
        return false
    }
}