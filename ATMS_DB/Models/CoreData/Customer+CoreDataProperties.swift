//
//  Customer+CoreDataProperties.swift
//  
//
//  Created by Ali Esmaeili on 12/27/23.
//
//

import Foundation
import CoreData


extension Customer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Customer> {
        return NSFetchRequest<Customer>(entityName: "Customer")
    }

    @NSManaged public var code: String?
    @NSManaged public var dateOfBirth: Date?
    @NSManaged public var gender: Bool
    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: String?

}
