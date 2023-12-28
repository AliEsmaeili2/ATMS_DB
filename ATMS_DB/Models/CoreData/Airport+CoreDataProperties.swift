//
//  Airport+CoreDataProperties.swift
//  
//
//  Created by Ali Esmaeili on 12/27/23.
//
//

import Foundation
import CoreData


extension Airport {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Airport> {
        return NSFetchRequest<Airport>(entityName: "Airport")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var place: String?

}
