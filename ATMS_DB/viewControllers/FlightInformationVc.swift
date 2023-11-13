//
//  FlightInformationVc.swift
//  ATMS_DB
//
//  Created by Ali Esmaeili on 11/13/23.
//

import UIKit
import DropDown

class FlightInformationVc: UIViewController {
    
    // MARK: @IBOutlet
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
    
    // MARK: DropDowns
    //dropDownAirport
    let dropDownAirport = DropDown()
    let airportArray = [" MehrAbad", " ImamKhomeini", "Dubai", "AlMaktoum", "Zone", "Hamad", "Hahn", "Vnukovo", "Sheremetyevo"]
    
    let airportArraySelected = [" MehrAbad-Tehran/Iran", " ImamKhomeini-Tehran/Iran", " Dubai-Dubai/UnitedArabEmirates", " AlMaktoum-Dubai/UnitedArabEmirates", " Zone-Doha/Qatar", " Hamad-Doha/Qatar", " Hahn-Frankfurt/Germany", " Vnukovo-Moscow/Russia", " Sheremetyevo-Moscow/Russia"]
    
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
    let travelSportsArray = [" Tehran", " Paris", " Rome", " London", " Washington"]
    let travelBusinessArray = [" Dubai", " NewYork", " Ankara"]
    let travelPilgrimageArray = [" Najaf", " Medina", " Mecca"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DropDown.appearance().selectedTextColor = .systemGreen
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().cornerRadius = 2
        
        // MARK: dropDownAirport
        DDLabelAirport.text = " Select Airport 🔽"
        
        dropDownAirport.anchorView = DDAirport
        dropDownAirport.dataSource = airportArray
        
        dropDownAirport.bottomOffset = CGPoint(x: 0, y:(dropDownAirport.anchorView?.plainView.bounds.height)!)
        dropDownAirport.direction = .bottom
        
        dropDownAirport.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Airport item: \(item) at index: \(index)")
            self.DDLabelAirport.text = airportArraySelected[index]
        }
        
        
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
            } else if item == " Premium" {
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
            } else if item == " Sports" {
                self.travelArray = self.travelSportsArray
            } else if item == " Pilgrimage" {
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
        }
        
    }
    
    // MARK: @IBAction
    
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
    
}
