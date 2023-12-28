//
//  Ticket+CoreDataProperties.swift
//  
//
//  Created by Ali Esmaeili on 12/27/23.
//
//

import Foundation
import CoreData


extension Ticket {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ticket> {
        return NSFetchRequest<Ticket>(entityName: "Ticket")
    }

    @NSManaged public var destination: String?
    @NSManaged public var flightDate: Date?
    @NSManaged public var id: Int16
    @NSManaged public var origin: String?
    @NSManaged public var price: String?
    @NSManaged public var seatNumber: Int16
    @NSManaged public var type: String?

}
