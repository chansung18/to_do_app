//
//  Color+CoreDataProperties.swift
//  to_do
//
//  Created by chansung on 9/19/16.
//  Copyright © 2016 chansung_eunkyo. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Color {

    @NSManaged var r: NSNumber?
    @NSManaged var g: NSNumber?
    @NSManaged var b: NSNumber?
    @NSManaged var a: NSNumber?
    @NSManaged var dolist: Dolist?

}
