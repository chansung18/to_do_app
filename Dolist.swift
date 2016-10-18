//
//  Dolist.swift
//  to_do
//
//  Created by Eunkyo, Seo on 9/13/16.
//  Copyright © 2016 chansung_eunkyo. All rights reserved.
//

import Foundation
import CoreData


class Dolist: NSManagedObject {
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
        startingDate = Date()
    }
}
