//
//  FlightTicketVc.swift
//  ATMS_DB
//
//  Created by Ali Esmaeili on 12/22/23.
//

import UIKit
import Foundation
import DropDown
import SkyFloatingLabelTextField
import CoreData

class FlightTicketVc: UIViewController {
    
    // MARK: @IBOutlet
    @IBOutlet weak var flightDate: UIDatePicker!
    @IBOutlet weak var origin: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var ticketPrice: UILabel!
    
    @IBOutlet weak var DDSeatNumber: UIView!
    @IBOutlet weak var labelSeatNumber: UILabel!
    
    @IBOutlet weak var DDTicketType: UIView!
    @IBOutlet weak var labelTicketType: UILabel!
    
    // MARK: variable
    var managedObjectContext: NSManagedObjectContext?
    
    let dropDownSeatNumber = DropDown()
    
    let dropDownTicketType = DropDown()
    var ticketTypeArray = [" FirstClass", " Business", " Premium", " Economy"]
    
    // array for TicketPrice
    let firstClassArray = ["790$", "680$", "810$", "850$"]
    let businessArray = ["400$", "520$", "430$", "490$"]
    let premiumArray = ["480$", "500$", "550$", "530$"]
    let economyArray = ["220$", "290$", "340$", "300$"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchOriginCityFromCoreData()
        fetchDestinationCityFromCoreData()
        
        // MARK: DDSeatNumber
        labelSeatNumber.text = " Select your Seat 🔽"
        
        dropDownSeatNumber.anchorView = DDSeatNumber
        dropDownSeatNumber.dataSource = generateRandomSeatNumbers(count: 10)
        
        dropDownSeatNumber.bottomOffset = CGPoint(x: 0, y:(dropDownSeatNumber.anchorView?.plainView.bounds.height)!)
        dropDownSeatNumber.direction = .bottom
        
        dropDownSeatNumber.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Seat Number: \(item) at index: \(index)")
            self.labelSeatNumber.text = item
            
        }
        
        // MARK: DDTicketType
        labelTicketType.text = " Select TicketType 🔽"
        
        dropDownTicketType.anchorView = DDTicketType
        dropDownTicketType.dataSource = ticketTypeArray
        
        dropDownTicketType.bottomOffset = CGPoint(x: 0, y:(dropDownTicketType.anchorView?.plainView.bounds.height)!)
        dropDownTicketType.direction = .bottom
        
        dropDownTicketType.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Seat Number: \(item) at index: \(index)")
            self.labelTicketType.text = item
            
            
            switch item {
            case " FirstClass":
                self.ticketPrice.text = selectRandomNumber(from: firstClassArray)
                
            case " Business":
                self.ticketPrice.text = selectRandomNumber(from: businessArray)
                
            case " Premium":
                self.ticketPrice.text = selectRandomNumber(from: premiumArray)
                
            case " Economy":
                self.ticketPrice.text = selectRandomNumber(from: economyArray)
                
            default:
                self.ticketPrice.text = nil
            }
        }
    }
    
    // MARK: function
    func generateRandomSeatNumbers(count: Int) -> [String] {
        
        var randomNumbers: [String] = []
        
        for _ in 1...count {
            
            let randomNumber = Int(arc4random_uniform(300))
            randomNumbers.append(" \(randomNumber)")
        }
        return randomNumbers
    }
    
    
    func selectRandomNumber(from array: [String]) -> String? {
        
        guard !array.isEmpty else {
            return nil
        }
        
        let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
        return array[randomIndex]
    }
    
    // MARK: @IBAction
    @IBAction func saveButton(_ sender: UIButton) {
        
        saveTicketToCoreData()
        //fetchTicketFromCoreData()
    }
    
    @IBAction func buttonSeatNumber(_ sender: Any) {
        
        dropDownSeatNumber.show()
    }
    
    @IBAction func buttonTicketType(_ sender: Any) {
        
        dropDownTicketType.show()
    }
}

// MARK: Extension
extension FlightTicketVc {
    
    // safe data's to core data
    func saveTicketToCoreData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let TicketEntity = NSEntityDescription.entity(forEntityName: "Ticket", in: managedObjectContext)!
        
        let ticket = Ticket(entity: TicketEntity, insertInto: managedObjectContext)
        if let seatNumberText = labelSeatNumber.text, let seatNumber = Int16(seatNumberText.trimmingCharacters(in: .whitespaces)) {
            ticket.seatNumber = seatNumber
            
        } else {
            print("Invalid seat number format")
            return
        }
        ticket.type = labelTicketType.text
        ticket.price = ticketPrice.text
        ticket.flightDate = flightDate.date
        
        do {
            try managedObjectContext.save()
            print("ticket saved to Core Data")
            
        } catch let error as NSError {
            print("Could not save ticket to Core Data. \(error), \(error.userInfo)")
        }
    }
}
