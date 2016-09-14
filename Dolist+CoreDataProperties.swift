//
//  Dolist+CoreDataProperties.swift
//  to_do
//
//  Created by Eunkyo, Seo on 9/14/16.
//  Copyright © 2016 chansung_eunkyo. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Dolist {

    @NSManaged var context: String?
    @NSManaged var deadline: NSDate?
    @NSManaged var decration: UNKNOWN_TYPE
    @NSManaged var startingDate: NSDate?
    @NSManaged var title: String?
    @NSManaged var alrams: NSData?

}
