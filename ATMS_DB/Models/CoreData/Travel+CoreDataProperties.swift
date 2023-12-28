//
//  Travel+CoreDataProperties.swift
//  
//
//  Created by Ali Esmaeili on 12/27/23.
//
//

import Foundation
import CoreData


extension Travel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Travel> {
        return NSFetchRequest<Travel>(entityName: "Travel")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var type: String?

}
