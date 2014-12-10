//
//  Contact.swift
//  CoreDataSearchBarDemo
//
//  Created by Ian MacCallum on 12/7/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import Foundation
import CoreData

class Contact: NSManagedObject {

    @NSManaged var nameLast: String
    @NSManaged var nameFirst: String

}
