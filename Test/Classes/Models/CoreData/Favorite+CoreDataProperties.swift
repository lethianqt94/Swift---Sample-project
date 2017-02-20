//
//  Favorite+CoreDataProperties.swift
//  Test
//
//  Created by Le Thi An on 12/16/15.
//  Copyright © 2015 Le Thi An. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Favorite {

    @NSManaged var author: String?
    @NSManaged var imageLink: String?
    @NSManaged var title: String?
    @NSManaged var type: NSNumber?
    @NSManaged var webViewLink: String?

}
