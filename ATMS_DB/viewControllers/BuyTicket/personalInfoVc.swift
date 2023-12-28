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
        
        // MARK: DD Gender
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
        
        customer.name = fullName.text
        customer.code = nationalCode.text
        customer.phoneNumber = phone.text
        customer.dateOfBirth = BirthDayPicker.date
        customer.gender = (DDLabel.text == " Male")
        
        do {
            try managedObjectContext.save()
            print("Customer Data saved successfully in coreData.")
            
        } catch let error as NSError {
            print("Could not save Customer data in coreData. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: @IBAction
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        saveToCoreData()
    }
    
    @IBAction func DDButton(_ sender: Any) {
        
        dropDown.show()
    }
}
