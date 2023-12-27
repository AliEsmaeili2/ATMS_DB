//
//  TicketVc.swift
//  ATMS_DB
//
//  Created by Ali Esmaeili on 11/6/23.
//

import UIKit
import DropDown
import SkyFloatingLabelTextField
import CoreData

class personalInfoVc: UIViewController {
    
    // MARK: @IBOutlet
    @IBOutlet weak var fullName: SkyFloatingLabelTextField!
    @IBOutlet weak var nationalCode: SkyFloatingLabelTextField!
    @IBOutlet weak var phone: SkyFloatingLabelTextField!
    @IBOutlet weak var BirthDayPicker: UIDatePicker!
    
    @IBOutlet weak var DDView: UIView!
    @IBOutlet weak var DDLabel: UILabel!
    
    var managedObjectContext: NSManagedObjectContext?
    let dropDown = DropDown()
    let genderArray = [" Male", " Female"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //coreData
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        // MARK: DD
        DDLabel.text = " Select Gender 🔽"
        DDView.layer.cornerRadius = 8
        
        // UIView or UIBarButtonItem
        dropDown.anchorView = DDView
        dropDown.dataSource = genderArray
        
        // Top of drop down will be below the anchorView
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.direction = .bottom
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.DDLabel.text = genderArray[index]
        }
        
        DropDown.appearance().selectedTextColor = .systemGreen
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().cornerRadius = 2
    }
    
    // MARK: Function
    
    //saveToCoreData
    func saveToCoreData() {
        
        guard let managedObjectContext = managedObjectContext else {
            return
        }
        // Create a new Customer entity object
        guard let entity = NSEntityDescription.entity(forEntityName: "Customer", in: managedObjectContext) else {
            return
        }
        let customer = Customer(entity: entity, insertInto: managedObjectContext)
        
        // Set the field values from the UI
        customer.name = fullName.text
        customer.code = nationalCode.text
        customer.phoneNumber = phone.text
        customer.dateOfBirth = BirthDayPicker.date
        customer.gender = (DDLabel.text == " Male")
        
        // Save the changes to Core Data
        do {
            try managedObjectContext.save()
            print("Customer Data saved successfully in coreData.")
        } catch let error as NSError {
            print("Could not save Customer data in coreData. \(error), \(error.userInfo)")
        }
    }
    
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
    
    // MARK: @IBAction
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        saveToCoreData()
        //deleteDataFromCoreData()
        fetchItemsFromCoreData()
    }
    
    @IBAction func DDButton(_ sender: Any) {
        
        dropDown.show()
    }
    
}
