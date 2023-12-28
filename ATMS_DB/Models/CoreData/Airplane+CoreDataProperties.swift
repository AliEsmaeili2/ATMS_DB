//
//  Airplane+CoreDataProperties.swift
//  
//
//  Created by Ali Esmaeili on 12/27/23.
//
//

import Foundation
import CoreData


extension Airplane {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Airplane> {
        return NSFetchRequest<Airplane>(entityName: "Airplane")
    }

    @NSManaged public var capacity: Int16
    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var type: String?

}
