//
//  Employee+CoreDataProperties.swift
//  
//
//  Created by Ali Esmaeili on 12/28/23.
//
//

import Foundation
import CoreData


extension Employee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee")
    }

    @NSManaged public var dateOfBirth: Date?
    @NSManaged public var gender: Bool
    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var type: String?
    @NSManaged public var namePDF: String?
    @NSManaged public var urlName: String?

}
