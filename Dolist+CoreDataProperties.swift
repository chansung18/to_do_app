//
//  Dolist+CoreDataProperties.swift
//  to_do
//
//  Created by Eunkyo, Seo on 9/29/16.
//  Copyright © 2016 chansung_eunkyo. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Dolist {

    @NSManaged var context: String?
    @NSManaged var deadline: Date?
    @NSManaged var decoration: String?
    @NSManaged var startingDate: Date?
    @NSManaged var title: String?
    @NSManaged var lineflag: NSNumber?
    @NSManaged var alarms: NSSet?
    @NSManaged var color: Color?

}
