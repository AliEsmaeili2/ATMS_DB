//
//  FlightInformationVc.swift
//  ATMS_DB
//
//  Created by Ali Esmaeili on 11/13/23.
//

import UIKit
import DropDown
import CoreData

class FlightInformationVc: UIViewController {
    
    // MARK: @IBOutlet
    //city
    @IBOutlet weak var DDcity: UIView!
    @IBOutlet weak var DDLabelCity: UILabel!
    
    //airport
    @IBOutlet weak var DDAirport: UIView!
    @IBOutlet weak var DDLabelAirport: UILabel!
    
    //airplaneType
    @IBOutlet weak var DDAirplaneType: UIView!
    @IBOutlet weak var DDLabelAirPlaneType: UILabel!
    
    //airplane
    @IBOutlet weak var DDVAirplane: UIView!
    @IBOutlet weak var DDLabelAirplane: UILabel!
    
    //travelType
    @IBOutlet weak var DDTravelType: UIView!
    @IBOutlet weak var DDLabelTravelType: UILabel!
    
    //travel
    @IBOutlet weak var DDTravel: UIView!
    @IBOutlet weak var DDLabelTravel: UILabel!
    
    //Destination Airport
    @IBOutlet weak var DDDestinationAirport: UIView!
    @IBOutlet weak var DDLabelDestinationAirport: UILabel!
    
    // MARK: DropDowns
    //dropDown City
    let dropDownCity = DropDown()
    let cityArray = [" Tehran", " Dubai", "Doha", "Frankfurt", "Moscow", "Paris", "London", "NewYork", "Ankara"]
    
    //dropDownAirport
    let dropDownAirport = DropDown()
    
    let tehranAirport = [" MehrAbad-Tehran/Iran(THR)", " ImamKhomeini-Tehran/Iran(IKA)"]
    let dubaiAirport = [" Dubai-Dubai/UnitedArabEmirates(DXB)", " AlMaktoum-Dubai/UnitedArabEmirates(DWC)"]
    let dohaAirport = [" Hamad-Doha/Qatar(DOH)"]
    let frankfurtAirport = [" Hahn-Frankfurt/Germany(HHN)"]
    let moscowAirport = [" Vnukovo-Moscow/Russia(VKO)", " Sheremetyevo-Moscow/Russia(SVO)"]
    let parisAirport = [" Orly-Paris/France(ORY)"]
    let londonAirport = [" Gatwick-London/England(LGW)", " Stansted-London/England(STN)"]
    let newYorkAirport = [" LaGuardia-NewYork/America(LGA)", " John F.Kennedy-NewYork/America(JFK)"]
    let ankaraAirport = [" Esenboğa-Ankara/Turkey(ESB)"]
    let meccaAirport = ["King Abdulaziz-Mecca/SaudiArabia(JED)"]
    let najafAirport = ["AlNajaf-Najaf/Iraq(NJF)"]
    let mashhadAirport = ["Mashhad-Mashhad/Iran(MHD)"]
    
    //dropDownAirplaneType
    let dropDownAirplaneType = DropDown()
    let airplaneTypeArray = [" AirLiner", " Premium"]
    
    //dropDownAirplane
    let dropDownAirplane = DropDown()
    var airplaneArray: [String] = []
    let airplaneAirlinerArray = [" Boeing 747", " Boeing 737", " Boeing 757",  " Boeing 767", " Airbus A300", " Airbus A310", " Airbus A380", " Airbus A330", " Airbus A350" ]
    let airplanePremiumArray = [" Boeing 717", " Boeing 777", " Boeing 787", " Airbus A320", " Airbus A340"]
    
    //dropDownTravelType
    let dropDownTravelType = DropDown()
    let travelTypeArray = [" Business", " Sports", " Pilgrimage"]
    
    //dropDownTravel
    let dropDownTravel = DropDown()
    var travelArray: [String] = []
    let travelSportsArray = [" Tehran", " Paris", " Dubai", " Ankara", " Moscow", " Doha"]
    let travelBusinessArray = [" Frankfurt", " NewYork", " London"]
    let travelPilgrimageArray = [" Najaf", " Mashhad", " Mecca"]
    
    //dropDown destinationAirport
    let dropDownDestinationAirport = DropDown()
    var destinationAirportArray: [String] = []
    
    var managedObjectContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DropDown.appearance().selectedTextColor = .systemGreen
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().cornerRadius = 2
        DropDown.appearance().shadowColor = .systemGreen
        
        DDAirport.layer.cornerRadius = 8
        DDAirplaneType.layer.cornerRadius = 8
        DDVAirplane.layer.cornerRadius = 8
        DDTravelType.layer.cornerRadius = 8
        DDTravel.layer.cornerRadius = 8
        
        // MARK: dropDown City
        DDLabelCity.text = " Select City 🔽"
        
        dropDownCity.anchorView = DDcity
        dropDownCity.dataSource = cityArray
        
        dropDownCity.bottomOffset = CGPoint(x: 0, y:(dropDownCity.anchorView?.plainView.bounds.height)!)
        dropDownCity.direction = .bottom
        
        dropDownCity.selectionAction = { [unowned self] (index: Int, item: String) in
            print("city item: \(item) at index: \(index)")
            self.DDLabelCity.text = cityArray[index]
            
            self.updateAirportDropDown(index: index)
            DDLabelAirport.text = " Select Airport 🔽"
        }
        
        // MARK: dropDownAirport
        DDLabelAirport.text = " Select Airport 🔽"
        
        dropDownAirport.anchorView = DDAirport
        dropDownAirport.dataSource = []
        
        dropDownAirport.bottomOffset = CGPoint(x: 0, y:(dropDownAirport.anchorView?.plainView.bounds.height)!)
        dropDownAirport.direction = .bottom
        
        // MARK: dropDownAirplaneType
        DDLabelAirPlaneType.text = " Select Airplane Type 🔽"
        
        dropDownAirplaneType.anchorView = DDAirplaneType
        dropDownAirplaneType.dataSource = airplaneTypeArray
        
        dropDownAirplaneType.bottomOffset = CGPoint(x: 0, y:(dropDownAirplaneType.anchorView?.plainView.bounds.height)!)
        dropDownAirplaneType.direction = .bottom
        
        dropDownAirplaneType.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Airplane Type item: \(item) at index: \(index)")
            self.DDLabelAirPlaneType.text = airplaneTypeArray[index]
            
            // Update the Airplane dropdown based on the selected Airplane Type
            if item == " AirLiner" {
                self.airplaneArray = self.airplaneAirlinerArray
            }
            else if item == " Premium" {
                self.airplaneArray = self.airplanePremiumArray
            }
            
            self.dropDownAirplane.dataSource = self.airplaneArray
            self.DDLabelAirplane.text = " Select Airplane 🔽"
        }
        
        // MARK: dropDownAirplane
        DDLabelAirplane.text = " Select Airplane 🔽"
        
        dropDownAirplane.anchorView = DDVAirplane
        dropDownAirplane.dataSource = airplaneArray
        
        dropDownAirplane.bottomOffset = CGPoint(x: 0, y:(dropDownAirplane.anchorView?.plainView.bounds.height)!)
        dropDownAirplane.direction = .bottom
        
        dropDownAirplane.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Airplane item: \(item) at index: \(index)")
            self.DDLabelAirplane.text = self.airplaneArray[index]
        }
        
        // MARK: dropDownTravelType
        DDLabelTravelType.text = " Select TravelType🔽"
        
        dropDownTravelType.anchorView = DDTravelType
        dropDownTravelType.dataSource = travelTypeArray
        
        dropDownTravelType.bottomOffset = CGPoint(x: 0, y:(dropDownTravelType.anchorView?.plainView.bounds.height)!)
        dropDownTravelType.direction = .bottom
        
        dropDownTravelType.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Travel Type item: \(item) at index: \(index)")
            self.DDLabelTravelType.text = travelTypeArray[index]
            
            if item == " Business" {
                self.travelArray = self.travelBusinessArray
            }
            else if item == " Sports" {
                self.travelArray = self.travelSportsArray
            }
            else if item == " Pilgrimage" {
                self.travelArray = self.travelPilgrimageArray
            }
            
            self.dropDownTravel.dataSource = self.travelArray
            self.DDLabelTravel.text = " Select Travel 🔽"
        }
        
        // MARK: dropDownTravel
        DDLabelTravel.text = " Select Travel 🔽"
        
        dropDownTravel.anchorView = DDTravel
        dropDownTravel.dataSource = travelArray
        
        dropDownTravel.bottomOffset = CGPoint(x: 0, y:(dropDownTravel.anchorView?.plainView.bounds.height)!)
        dropDownTravel.direction = .bottom
        
        dropDownTravel.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Travel item: \(item) at index: \(index)")
            self.DDLabelTravel.text = self.travelArray[index]
            
            if item == " Tehran" {
                self.destinationAirportArray = self.tehranAirport
            }
            else if item == " Paris" {
                self.destinationAirportArray = self.parisAirport
            }
            else if item == " Dubai" {
                self.destinationAirportArray = self.dubaiAirport
            }
            else if item == " Ankara" {
                self.destinationAirportArray = self.ankaraAirport
            }
            else if item == " Moscow" {
                self.destinationAirportArray = self.moscowAirport
            }
            else if item == " Doha" {
                self.destinationAirportArray = self.dohaAirport
            }
            else if item == " Frankfurt" {
                self.destinationAirportArray = self.frankfurtAirport
            }
            else if item == " NewYork" {
                self.destinationAirportArray = self.newYorkAirport
            }
            else if item == " London" {
                self.destinationAirportArray = self.londonAirport
            }
            else if item == " Najaf" {
                self.destinationAirportArray = self.najafAirport
            }
            else if item == " Mecca" {
                self.destinationAirportArray = self.meccaAirport
            }
            else if item == " Mashhad" {
                self.destinationAirportArray = self.mashhadAirport
            }
            
            self.dropDownDestinationAirport.dataSource = self.destinationAirportArray
            DDLabelDestinationAirport.text = " Select Destination Airport 🔽"
        }
        
        // MARK: dropDown DestinationAirport
        DDLabelDestinationAirport.text = " Select Destination Airport 🔽"
        
        dropDownDestinationAirport.anchorView = DDDestinationAirport
        dropDownDestinationAirport.dataSource = destinationAirportArray
        
        dropDownDestinationAirport.bottomOffset = CGPoint(x: 0, y:(dropDownDestinationAirport.anchorView?.plainView.bounds.height)!)
        dropDownDestinationAirport.direction = .bottom
        
        dropDownDestinationAirport.selectionAction = { [unowned self] (index: Int, item: String) in
            print("city item: \(item) at index: \(index)")
            self.DDLabelDestinationAirport.text = destinationAirportArray[index]
            
        }
    }
    
    // MARK: Function
    // Function to update the airport array based on the selected city
    func updateAirportDropDown(index: Int) {
        switch index {
        case 0: // Tehran
            dropDownAirport.dataSource = tehranAirport
            dropDownAirport.selectionAction = { [unowned self] (index: Int, item: String) in
                print("Airport item: \(item) at index: \(index)")
                self.DDLabelAirport.text = tehranAirport[index]
            }
        case 1: // Dubai
            dropDownAirport.dataSource = dubaiAirport
            dropDownAirport.selectionAction = { [unowned self] (index: Int, item: String) in
                print("Airport item: \(item) at index: \(index)")
                self.DDLabelAirport.text = dubaiAirport[index]
            }
        case 2: // Doha
            dropDownAirport.dataSource = dohaAirport
            dropDownAirport.selectionAction = { [unowned self] (index: Int, item: String) in
                print("Airport item: \(item) at index: \(index)")
                self.DDLabelAirport.text = dohaAirport[index]
            }
        case 3: // Frankfurt
            dropDownAirport.dataSource = frankfurtAirport
            dropDownAirport.selectionAction = { [unowned self] (index: Int, item: String) in
                print("Airport item: \(item) at index: \(index)")
                self.DDLabelAirport.text = frankfurtAirport[index]
            }
        case 4: // Moscow
            dropDownAirport.dataSource = moscowAirport
            dropDownAirport.selectionAction = { [unowned self] (index: Int, item: String) in
                print("Airport item: \(item) at index: \(index)")
                self.DDLabelAirport.text = moscowAirport[index]
            }
        case 5: // Paris
            dropDownAirport.dataSource = parisAirport
            dropDownAirport.selectionAction = { [unowned self] (index: Int, item: String) in
                print("Airport item: \(item) at index: \(index)")
                self.DDLabelAirport.text = parisAirport[index]
            }
        case 6: // London
            dropDownAirport.dataSource = londonAirport
            dropDownAirport.selectionAction = { [unowned self] (index: Int, item: String) in
                print("Airport item: \(item) at index: \(index)")
                self.DDLabelAirport.text = londonAirport[index]
            }
        case 7: // New York
            dropDownAirport.dataSource = newYorkAirport
            dropDownAirport.selectionAction = { [unowned self] (index: Int, item: String) in
                print("Airport item: \(item) at index: \(index)")
                self.DDLabelAirport.text = newYorkAirport[index]
            }
        case 8: // Ankara
            dropDownAirport.dataSource = ankaraAirport
            dropDownAirport.selectionAction = { [unowned self] (index: Int, item: String) in
                print("Airport item: \(item) at index: \(index)")
                self.DDLabelAirport.text = ankaraAirport[index]
            }
        default:
            dropDownAirport.dataSource = [] // Empty array for unknown selection
        }
        dropDownAirport.reloadAllComponents()
    }
    
    // MARK: @IBAction
    @IBAction func DDButtonCity(_ sender: Any) {
        
        dropDownCity.show()
    }
    
    @IBAction func DDButtonAirport(_ sender: Any) {
        
        dropDownAirport.show()
    }
    
    @IBAction func DDButtonAirPlaneType(_ sender: Any) {
        
        dropDownAirplaneType.show()
    }
    
    @IBAction func DDButtonAirplane(_ sender: Any) {
        
        dropDownAirplane.show()
    }
    
    @IBAction func DDButtonTravelType(_ sender: Any) {
        
        dropDownTravelType.show()
    }
    
    @IBAction func DDButtonTravel(_ sender: Any) {
        
        dropDownTravel.show()
    }
    
    @IBAction func DDButtonDestinationAirport(_ sender: Any) {
        
        dropDownDestinationAirport.show()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        saveAirportToCoreData()
        //  fetchAirportFromCoreData()
        saveAirplaneToCoreData()
        //  fetchAirplaneFromCoreData()
        saveTravelToCoreData()
        //  fetchTravelFromCoreData()
    }
}

// MARK: extension
extension FlightInformationVc {
    
    //save data's to CoreData
    func saveAirportToCoreData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let airportEntity = NSEntityDescription.entity(forEntityName: "Airport", in: managedObjectContext)!
        
        let airport = NSManagedObject(entity: airportEntity, insertInto: managedObjectContext)
        
        airport.setValue(DDLabelAirport.text, forKeyPath: "place")
        airport.setValue(DDLabelCity.text, forKeyPath: "name")
        
        do {
            try managedObjectContext.save()
            print("Airport saved to Core Data")
            
        } catch let error as NSError {
            print("Could not save Airport to Core Data. \(error), \(error.userInfo)")
        }
    }
    
    func saveAirplaneToCoreData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let AirplaneEntity = NSEntityDescription.entity(forEntityName: "Airplane", in: managedObjectContext)!
        
        let airplane = NSManagedObject(entity: AirplaneEntity, insertInto: managedObjectContext)
        
        airplane.setValue(DDLabelAirplane.text, forKeyPath: "name")
        airplane.setValue(DDLabelAirPlaneType.text, forKeyPath: "type")
        
        do {
            try managedObjectContext.save()
            print("Airplane saved to Core Data")
            
        } catch let error as NSError {
            print("Could not save airplane to Core Data. \(error), \(error.userInfo)")
        }
    }
    
    func saveTravelToCoreData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let TravelEntity = NSEntityDescription.entity(forEntityName: "Travel", in: managedObjectContext)!
        
        let travel = NSManagedObject(entity: TravelEntity, insertInto: managedObjectContext)
        
        travel.setValue(DDLabelTravel.text, forKeyPath: "name")
        travel.setValue(DDLabelDestinationAirport.text, forKeyPath: "type")
        
        do {
            try managedObjectContext.save()
            print("Travel saved to Core Data")
            
        } catch let error as NSError {
            print("Could not save Travel to Core Data. \(error), \(error.userInfo)")
        }
    }
}
