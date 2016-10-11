//
//  Color+CoreDataProperties.swift
//  to_do
//
//  Created by chansung on 10/11/16.
//  Copyright © 2016 chansung_eunkyo. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Color {

    @NSManaged var a: NSNumber?
    @NSManaged var b: NSNumber?
    @NSManaged var g: NSNumber?
    @NSManaged var r: NSNumber?
    @NSManaged var index: NSNumber?
    @NSManaged var dolist: Dolist?

}
