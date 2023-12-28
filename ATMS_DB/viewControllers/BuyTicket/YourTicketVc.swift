//
//  YourTicketVc.swift
//  ATMS_DB
//
//  Created by Ali Esmaeili on 12/22/23.
//

import UIKit
import Foundation
import CoreData
import PDFKit
import SwiftMessages

class YourTicketVc: UIViewController {
    
    // MARK: @IBOutlet
    //image
    @IBOutlet weak var showPdf: UIView!
    
    @IBOutlet weak var companyLogo: UIImageView!
    @IBOutlet weak var QRCodeLogo: UIImageView!
    
    //ticket
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var flightCode: UILabel!
    @IBOutlet weak var originCity: UILabel!
    @IBOutlet weak var destinationCity: UILabel!
    @IBOutlet weak var boardingTime: UILabel!
    @IBOutlet weak var flightDate: UILabel!
    @IBOutlet weak var flightGate: UILabel!
    @IBOutlet weak var seatNum: UILabel!
    
    //boarding pass
    @IBOutlet weak var ticketType: UILabel!
    
    //variable
    
    private var pdfView: PDFView?
    private var pdfDocument: PDFDocument?
    
    let flightCodeArray = ["A34F9C", "M23Z51", "S35V88", "Q98B7X", "W76C01", "R11Z1Q", "E47N51", "T86W1W", "Y04G4E", "P30L91", "K17J1J", "F63C4Z", "H25I4R", "X68A2U", "N00M7D"]
    
    let gateArray = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCustomerDataFromCoreData()
        fetchOrgAirDataFromCoreData()
        fetchDesAirDataFromCoreData()
        fetchTicketDataFromCoreData()
        
        self.flightCode.text = generateRandomCode(from: flightCodeArray)
        self.flightGate.text = generateRandomCode(from: gateArray)
    }
    
    // MARK: function
    
    func generateRandomCode(from array: [String]) -> String? {
        
        guard !array.isEmpty else {
            return nil
        }
        
        let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
        return array[randomIndex]
    }
    
    //fetchCustomerDataFromCoreData
    func fetchCustomerDataFromCoreData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Customer> = Customer.fetchRequest()
        
        do {
            let customers = try managedObjectContext.fetch(fetchRequest)
            if let customer = customers.last {
                
                fullName.text = customer.name
            }
        } catch let error as NSError {
            print("Could not fetch data. \(error), \(error.userInfo)")
        }
    }
    
    func fetchOrgAirDataFromCoreData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Airport> = Airport.fetchRequest()
        
        do {
            let customers = try managedObjectContext.fetch(fetchRequest)
            if let customer = customers.last {
                
                originCity.text = customer.name
            }
        } catch let error as NSError {
            print("Could not fetch data. \(error), \(error.userInfo)")
        }
    }
    
    func fetchDesAirDataFromCoreData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Travel> = Travel.fetchRequest()
        
        do {
            let customers = try managedObjectContext.fetch(fetchRequest)
            if let customer = customers.last {
                
                destinationCity.text = customer.name
            }
        } catch let error as NSError {
            print("Could not fetch data. \(error), \(error.userInfo)")
        }
    }
    
    func fetchTicketDataFromCoreData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Ticket> = Ticket.fetchRequest()
        
        do {
            let tickets = try managedObjectContext.fetch(fetchRequest)
            
            if let ticket = tickets.last {
                
                if let flightDate = ticket.flightDate, let flightTime = ticket.flightDate {
                    
                    let dateFormatter = DateFormatter()
                    let timeFormatter = DateFormatter()
                    dateFormatter.dateStyle = .short
                    timeFormatter.timeStyle = .short
                    let formattedDate = dateFormatter.string(from: flightDate)
                    let formattedTime = timeFormatter.string(from: flightTime)
                    
                    self.flightDate.text = formattedDate
                    self.boardingTime.text = formattedTime
                }
                
                
                if let seatNumber = ticket.seatNumber as Int16? {
                    self.seatNum.text = String(seatNumber)
                }
            }
        } catch let error as NSError {
            print("Could not fetch data. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: @IBAction
    @IBAction func Okbutton(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Choose Option", message: nil, preferredStyle: .actionSheet)
        
        let EditAction = UIAlertAction(title: "Edit", style: .default) { _ in
        }
        
        let DownloadAction = UIAlertAction(title: "Download PDF", style: .default) { _ in
            
            self.generatePDF()
            print("click on download PDF button")
        }
        DownloadAction.setValue(UIColor.systemGreen, forKey: "titleTextColor")
        
        // Cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Add actions to the alert controller
        alertController.addAction(EditAction)
        alertController.addAction(DownloadAction)
        alertController.addAction(cancelAction)
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    
}

// MARK: extention
extension YourTicketVc {
    
    //func generate PDF
    func generatePDF() {
        // Create an alert controller with a text field
        let alertController = UIAlertController(title: "Enter PDF Name", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "PDF Name"
        }
        
        // Add a Save action to the alert controller
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            if let pdfName = alertController.textFields?.first?.text, !pdfName.isEmpty {
                // Define A4 paper size
                let pageSize = CGSize(width: 600, height: 875) // A4 in points (72 points per inch)
                
                // Create a PDF context with the defined page size
                let pdfData = NSMutableData()
                let pdfFormat = UIGraphicsPDFRendererFormat()
                
                let renderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: pageSize), format: pdfFormat)
                
                // Get the app's Documents directory URL
                let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                
                // Create a unique file URL for the PDF in the Documents directory
                let pdfURL = documentsDirectoryURL.appendingPathComponent("\(pdfName).pdf")
                
                // Start the PDF rendering
                try? renderer.writePDF(to: pdfURL) { (context) in
                    context.beginPage()
                    
                    // Capture the content of the showPdf view as an image
                    UIGraphicsBeginImageContextWithOptions(self.showPdf.bounds.size, false, 0.0)
                    if let context = UIGraphicsGetCurrentContext() {
                        self.showPdf.layer.render(in: context)
                    }
                    if let pdfImage = UIGraphicsGetImageFromCurrentImageContext() {
                        UIGraphicsEndImageContext()
                        
                        // Calculate the scaling factor to fit the image within the page
                        let scaleFactor = min(pageSize.width / pdfImage.size.width, pageSize.height / pdfImage.size.height)
                        let scaledSize = CGSize(width: pdfImage.size.width * scaleFactor, height: pdfImage.size.height * scaleFactor)
                        
                        // Center the image on the page
                        let x = (pageSize.width - scaledSize.width) / 2
                        let y = (pageSize.height - scaledSize.height) / 2
                        
                        // Draw the captured image onto the PDF context, centered on the page
                        pdfImage.draw(in: CGRect(x: x, y: y, width: scaledSize.width, height: scaledSize.height))
                    }
                }
                
                // Save the PDF URL and name to CoreData
                self.savePDFToCoreData(url: pdfURL, name: pdfName)
                
                print("PDF saved to: \(pdfURL.path)")
                
                let messageSuccess = MessageView.viewFromNib(layout: .cardView)
                messageSuccess.configureTheme(.success)
                messageSuccess.configureContent(title: "Successfully Save PDF", body: "You can see it in History!")
                messageSuccess.button?.isHidden = true
                SwiftMessages.show(view: messageSuccess)
                
            } else {
                // Show an error message if the PDF name is empty
                let errorMessage = MessageView.viewFromNib(layout: .cardView)
                errorMessage.configureTheme(.error)
                errorMessage.configureContent(title: "", body: "Please enter a valid PDF name.")
                errorMessage.button?.isHidden = true
                SwiftMessages.show(view: errorMessage)
            }
        }
        alertController.addAction(saveAction)
        
        // Add a Cancel action to the alert controller
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    
    func savePDFToCoreData(url: URL, name: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let history = Employee(context: context)
        
        history.urlName = url.path
        history.namePDF = name
        
        do {
            try context.save()
            print("PDF URL saved to CoreData")
            
        } catch {
            print("Failed to save PDF URL to CoreData: \(error)")
        }
    }
}
