//
//  EmployeeInfoVc.swift
//  ATMS_DB
//
//  Created by Ali Esmaeili on 12/29/23.
//

import UIKit
import Foundation
import CoreData
import DropDown
import SwiftMessages
import SkyFloatingLabelTextField

class EmployeeInfoVc: UIViewController {
    
    // MARK: @IBOutlet
    @IBOutlet weak var fullName: SkyFloatingLabelTextField!
    @IBOutlet weak var employeeID: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var birthDay: UIDatePicker!
    
    @IBOutlet weak var DDGender: UIView!
    @IBOutlet weak var labelGender: UILabel!
    
    @IBOutlet weak var DDJobPosition: UIView!
    @IBOutlet weak var labelJobPosition: UILabel!
    @IBOutlet weak var VButton: UIButton!
    
    // MARK: variable
    var managedObjectContext: NSManagedObjectContext?
    
    let dropDownGender = DropDown()
    let genderArray = [" Male", " Female"]
    
    let dropDownJob = DropDown()
    let jobArray = [" Co-Pilot", " FlightCare", " Stewardess", " Pilot"]
    
    // employee info
    let user100 = ["ali esmaeili", "100", " Co-Pilot"]
    
    let user201 = ["aslan miri", "201", " Co-Pilot"]
    let user202 = ["sheyda ajodani", "202", " Co-Pilot"]
    let user203 = ["ahmad vahedi", "203", " Co-Pilot"]
    
    let user301 = ["tina mahmodi", "301", " Stewardess"]
    let user302 = ["zeynab salimi", "302", " Stewardess"]
    let user303 = ["roya darvish", "303", " Stewardess"]
    
    let user401 = ["hadi taqavi", "401", " FlightCare"]
    let user402 = ["aida akbari", "402", " FlightCare"]
    let user403 = ["bita molaei", "403", " FlightCare"]
    
    let user501 = ["milad mohebi", "501", " Pilot"]
    let user502 = ["babak larijani", "502", " Pilot"]
    let user503 = ["shahin karimi", "503", " Pilot"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fullName.addTarget(self, action: #selector(nameDidChange(_:)), for: .editingChanged)
        self.view.addSubview(fullName)
        fullnameTF()
        
        employeeID.addTarget(self, action: #selector(IDDidChange(_:)), for: .editingChanged)
        self.view.addSubview(employeeID)
        
        //coreData
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        // MARK: DD Gender
        labelGender.text = " Select Gender 🔽"
        DDGender.layer.cornerRadius = 8
        
        dropDownGender.anchorView = DDGender
        dropDownGender.dataSource = genderArray
        
        dropDownGender.bottomOffset = CGPoint(x: 0, y:(dropDownGender.anchorView?.plainView.bounds.height)!)
        dropDownGender.direction = .bottom
        
        dropDownGender.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.labelGender.text = genderArray[index]
        }
        
        DropDown.appearance().selectedTextColor = .systemGreen
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().cornerRadius = 2
        
        // MARK: DD JobPosition
        labelJobPosition.text = " Select Job Position 🔽"
        DDJobPosition.layer.cornerRadius = 8
        
        dropDownJob.anchorView = DDJobPosition
        dropDownJob.dataSource = jobArray
        
        dropDownJob.bottomOffset = CGPoint(x: 0, y:(dropDownJob.anchorView?.plainView.bounds.height)!)
        dropDownJob.direction = .bottom
        
        dropDownJob.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.labelJobPosition.text = jobArray[index]
        }
    }
    
    // MARK: Function
    //saveToCoreData
    func saveToCoreData() {
        
        guard let managedObjectContext = managedObjectContext else {
            return
        }
        guard let entity = NSEntityDescription.entity(forEntityName: "Employee", in: managedObjectContext) else {
            return
        }
        let employee = Employee(entity: entity, insertInto: managedObjectContext)
        
        employee.name = fullName.text
        employee.phoneNumber = phoneNumber.text
        employee.dateOfBirth = birthDay.date
        employee.gender = (labelGender.text == " Male")
        employee.setValue(labelJobPosition.text, forKeyPath: "type")
        
        if let IDText = employeeID.text, let ID = Int16(IDText.trimmingCharacters(in: .whitespaces)) {
            employee.id = ID
        }
        
        do {
            try managedObjectContext.save()
            print("Employee Data saved successfully in coreData.")
            
        } catch let error as NSError {
            print("Could not save Employee data in coreData. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: @IBAction
    @IBAction func verifyButton(_ sender: LoaderButton) {
        
        sender.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            sender.isLoading = false
            
            let fullNameText = self.fullName.text ?? ""
            let employeeIDText = self.employeeID.text ?? ""
            let jobPositionText = self.labelJobPosition.text ?? ""
            
            var foundMatch = false
            
            let userArrays = [self.user100, self.user201, self.user202, self.user203, self.user301, self.user302, self.user303, self.user401, self.user402, self.user403, self.user501, self.user501, self.user502, self.user503]
            
            for userArray in userArrays {
                
                let userFullName = userArray[0]
                let userID = userArray[1]
                let userJobPosition = userArray[2]
                
                if fullNameText == userFullName && employeeIDText == userID && jobPositionText == userJobPosition {
                    
                    let messageSuccess = MessageView.viewFromNib(layout: .cardView)
                    messageSuccess.configureTheme(.success)
                    messageSuccess.configureContent(title: "Confirmation done!", body: "You have successfully Logged in!")
                    messageSuccess.button?.isHidden = true
                    SwiftMessages.show(view: messageSuccess)
                    
                    foundMatch = true
                    
                    break
                }
            }
            
            if foundMatch {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let nextViewController = storyboard.instantiateViewController(withIdentifier: "VerifyPage")
                
                self.navigationController?.pushViewController(nextViewController, animated: true)
                
            } else {
                
                let errorMessage = MessageView.viewFromNib(layout: .cardView)
                errorMessage.configureTheme(.error)
                errorMessage.configureContent(title: "Not confirmed!", body: "Please enter the correct information!")
                errorMessage.button?.isHidden = true
                SwiftMessages.show(view: errorMessage)
            }
        }
        
        saveToCoreData()
    }
    
    @IBAction func genderButton(_ sender: Any) {
        
        dropDownGender.show()
    }
    
    @IBAction func JobPositionButton(_ sender: Any) {
        
        dropDownJob.show()
    }
}
