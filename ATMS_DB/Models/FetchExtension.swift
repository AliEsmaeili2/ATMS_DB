//
//  FetchExtension.swift
//  ATMS_DB
//
//  Created by Ali Esmaeili on 12/28/23.
//

import Foundation
import UIKit
import CoreData

// MARK: Flight Information Vc
extension FlightInformationVc {
    
    func fetchAirportFromCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Airport")
        
        do {
            let airports = try managedObjectContext.fetch(fetchRequest) as! [Airport]
            
            for airport in airports {
                if let name = airport.name, let place = airport.place {
                    print("Airport Name: \(name), Place: \(place)")
                }
            }
        } catch let error as NSError {
            print("Could not fetch airports from Core Data. \(error), \(error.userInfo)")
        }
    }
    
    func fetchAirplaneFromCoreData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Airplane")
        
        do {
            let airplane1 = try managedObjectContext.fetch(fetchRequest) as! [Airplane]
            
            for airplane in airplane1 {
                
                if let name = airplane.name, let type = airplane.type {
                    print("Airplane Name: \(name), Type: \(type)")
                }
            }
        } catch let error as NSError {
            print("Could not fetch Airplane from Core Data. \(error), \(error.userInfo)")
        }
    }
    
    func fetchTravelFromCoreData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Travel")
        
        do {
            let travel1 = try managedObjectContext.fetch(fetchRequest) as! [Travel]
            
            for travel in travel1 {
                
                if let name = travel.name, let type = travel.type {
                    print("Travel Name: \(name), Type: \(type)")
                }
            }
        } catch let error as NSError {
            print("Could not fetch Travel from Core Data. \(error), \(error.userInfo)")
        }
    }
}

// MARK: Personal Info Vc
extension personalInfoVc {
    
    //fetchFromCoreData
    func fetchItemsFromCoreData() {
        guard let managedObjectContext = managedObjectContext else {
            return
        }
        
        let fetchRequest: NSFetchRequest<Customer> = Customer.fetchRequest()
        
        do {
            let customers = try managedObjectContext.fetch(fetchRequest)
            // Process the fetched customers
            for customer in customers {
                print("fetch Data: ...")
                print("Name: \(customer.name ?? "")")
                print("Code: \(customer.code ?? "")")
                print("Phone: \(customer.phoneNumber ?? "")")
                print("Birth Date: \(customer.dateOfBirth ?? Date())")
                print("Gender: \(customer.gender ? "Male" : "Female")")
                print("----------")
            }
        } catch let error as NSError {
            print("Could not fetch data. \(error), \(error.userInfo)")
        }
    }
    
    // deleteFromCoreData
    func deleteDataFromCoreData() {
        
        guard let managedObjectContext = managedObjectContext else {
            return
        }
        
        let fetchRequest: NSFetchRequest<Customer> = Customer.fetchRequest()
        
        do {
            let customers = try managedObjectContext.fetch(fetchRequest)
            
            // Loop through fetched customers and delete them one by one
            for customer in customers {
                managedObjectContext.delete(customer)
            }
            
            // Save the changes after deleting
            try managedObjectContext.save()
            print("Customer Data deleted successfully from coreData.")
        } catch let error as NSError {
            print("Could not delete Customer data from coreData. \(error), \(error.userInfo)")
        }
    }
}

// MARK: Flight Ticket Vc
extension FlightTicketVc {
    
    func fetchTicketFromCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Ticket")
        
        do {
            let tickets = try managedObjectContext.fetch(fetchRequest) as! [Ticket]
            
            for ticket in tickets {
                let seat = ticket.seatNumber
                let type = ticket.type
                let price = ticket.price
                
                print("Ticket seat: \(seat), type: \(type ?? ""), price: \(price ?? "")")
            }
        } catch let error as NSError {
            print("Could not fetch Ticket from Core Data. \(error), \(error.userInfo)")
        }
    }
    
    func fetchOriginCityFromCoreData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Airport> = Airport.fetchRequest()
        
        do {
            let OriginCity1 = try managedObjectContext.fetch(fetchRequest)
            
            if let OriginCity = OriginCity1.last {
                
                origin.text = OriginCity.place
            }
        } catch let error as NSError {
            print("Could not fetch data. \(error), \(error.userInfo)")
        }
    }
    
    func fetchDestinationCityFromCoreData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Travel> = Travel.fetchRequest()
        
        do {
            let DestinationCity1 = try managedObjectContext.fetch(fetchRequest)
            
            if let DestinationCity = DestinationCity1.last {
                
                destination.text = DestinationCity.type
            }
        } catch let error as NSError {
            print("Could not fetch data. \(error), \(error.userInfo)")
        }
    }
}

// MARK: EmployeeInfo Vc
extension EmployeeInfoVc {
    
    func fetchItemsFromCoreData() {
        
        guard let managedObjectContext = managedObjectContext else {
            return
        }
        
        let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()
        
        do {
            let employee1 = try managedObjectContext.fetch(fetchRequest)
            for employee in employee1 {
                print("ID: \(employee.id)")
                print("Name: \(employee.name ?? "")")
                print("Phone: \(employee.phoneNumber ?? "")")
                print("Birth Date: \(employee.dateOfBirth ?? Date())")
                print("Gender: \(employee.gender ? "Male" : "Female")")
                print("jobType: \(employee.type)")

                print("----------")
            }
        } catch let error as NSError {
            print("Could not fetch data. \(error), \(error.userInfo)")
        }
    }
}
