//
//  verifyEmployeeVc.swift
//  ATMS_DB
//
//  Created by Ali Esmaeili on 12/30/23.
//

import UIKit
import Foundation
import CoreData
import SwiftMessages

class verifyEmployeeVc: UIViewController {
    
    // MARK: @IBOutlet
    @IBOutlet weak var fName: UILabel!
    @IBOutlet weak var EmpID: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var EmpGender: UILabel!
    @IBOutlet weak var EmpType: UILabel!
    @IBOutlet weak var empBD: UILabel!
    
    @IBOutlet weak var flight1: UILabel!
    @IBOutlet weak var flight2: UILabel!
    @IBOutlet weak var flight3: UILabel!
    
    // MARK: var
    let flightArray1 = ["Tehran To Dubai : 31/12/2023", "London To NewYork : 23/01/2024", "Najaf To Tehran : 12/02/2024", "Frankfurt To Doha : 29/03/2024", "Doha To Ankara : 01/04/2024", "Moscow To Pekan : 11/03/2024"]
    
    let flightArray2 = ["Pekan To Dubai : 30/02/2024", "Doha To NewYork : 27/02/2024", "Mecca To Tehran : 13/03/2024", "Frankfurt To Paris : 20/01/2024", "London To Ankara : 02/04/2024", "Moscow To Tehran : 19/05/2024"]
    
    let flightArray3 = ["Dubai To Paris : 07/06/2024", "London To Tehran : 25/01/2024", "Doha To Tehran : 15/01/2024", "Frankfurt To NewYork : 18/03/2024", "Moscow To Ankara : 09/02/2024", "NewYork To Pekan : 03/03/2024"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "EMPLOYEE ACCESS CONTROL☑️"
        navigationItem.prompt = " "
        navigationItem.backButtonTitle = " "
        
        fetchEmployeeFromCoreData()
        
        self.flight1.text = selectRandomArray(from: flightArray1)
        self.flight2.text = selectRandomArray(from: flightArray2)
        self.flight3.text = selectRandomArray(from: flightArray3)
    }
    
    // MARK: Function
    //fetch form coreData
    func fetchEmployeeFromCoreData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()
        
        do {
            let emp = try managedObjectContext.fetch(fetchRequest)
            
            if let employee = emp.last {
                
                if let BDate = employee.dateOfBirth {
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .medium
                    let formattedDate = dateFormatter.string(from: BDate)
                    self.empBD.text = formattedDate
                }
                
                if let id = employee.id as Int16? {
                    
                    self.EmpID.text = String(id)
                }
                
                self.fName.text = employee.name
                self.phone.text = employee.phoneNumber
                self.EmpGender.text = employee.gender ? "Male" : "Female"
                self.EmpType.text = employee.type
                
            }
        }
        catch let error as NSError {
            print("Could not fetch Emp data. \(error), \(error.userInfo)")
        }
    }
    
    //select random items inside array
    func selectRandomArray(from array: [String]) -> String? {
        
        guard !array.isEmpty else {
            return nil
        }
        let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
        return array[randomIndex]
    }
}
