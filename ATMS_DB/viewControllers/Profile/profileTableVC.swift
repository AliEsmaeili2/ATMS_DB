//
//  profileTableVC.swift
//  ATMS_DB
//
//  Created by Ali Esmaeili on 12/12/23.
//

import UIKit
import Foundation
import SwiftMessages
import MessageUI
import SafariServices
import WebKit
import StoreKit


class profileTableVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

  //  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
   //     return 0
  //  }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 3 && indexPath.row == 0 {
            
            loggedOut()
        }
        
        else if indexPath.section == 1 && indexPath.row == 5 {
            
            shareApp()
        }
        
        else if indexPath.section == 1 && indexPath.row == 4 {
            
            privacyPolicy()
        }
        
        else if indexPath.section == 1 && indexPath.row == 3 {
            
            termOfService()
        }
        
        else if indexPath.section == 1 && indexPath.row == 2 {
            
            sendEmail()
        }
        
        else if indexPath.section == 1 && indexPath.row == 1 {
            
            rateApp()
        }
        
        else if indexPath.section == 1 && indexPath.row == 0 {
            
            aboutUs()
        }
        
        else if indexPath.section == 2 && indexPath.row == 2 {
            
            website()
        }
        
        else if indexPath.section == 2 && indexPath.row == 1 {
            
            twitter()
        }
        
        else if indexPath.section == 2 && indexPath.row == 0 {
            
            instagram()
        }
    }
    
    // MARK: - Functions
    func termOfService() {
        
        if let url = URL(string: "https://www.apple.com") {
            UIApplication.shared.open(url)
        }
    }
    
    func privacyPolicy() {
        
        if let url = URL(string: "https://www.google.com") {
            UIApplication.shared.open(url)
        }
    }
    
    func aboutUs() {
        
        if let url = URL(string: "https://www.github.com") {
            UIApplication.shared.open(url)
        }
    }
    
    func instagram() {
        
        if let url = URL(string: "https://www.instagram.com") {
            UIApplication.shared.open(url)
        }
    }
    
    func twitter() {
        
        if let url = URL(string: "https://twitter.com") {
            UIApplication.shared.open(url)
        }
    }
    
    func website() {
        
        if let url = URL(string: "https://air.com") {
            UIApplication.shared.open(url)
        }
    }
    
    func rateApp() {
        
    }
    
    func shareApp() {
        // The content you want to share (e.g., app store link)
        let appStoreLink = "https://apps.apple.com"
        
        // Create an activity view controller
        let activityViewController = UIActivityViewController(activityItems: [appStoreLink], applicationActivities: nil)
        
        // Configure the activity view controller
        activityViewController.popoverPresentationController?.sourceView = self.view // For iPad support
        
        // Present the activity view controller
        present(activityViewController, animated: true, completion: nil)
    }
    
    func loggedOut() {
        

    }
}
// MARK: - Extansion
extension profileTableVC: MFMailComposeViewControllerDelegate {
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.setToRecipients(["aliesmaeili.developer@gmail.com"])
            mailComposer.setSubject("Feedback")
            mailComposer.setMessageBody("", isHTML: false)
            present(mailComposer, animated: true, completion: nil)
        }
        else {
            
            let errorEmail = MessageView.viewFromNib(layout: .cardView)
            errorEmail.configureTheme(.info)
            errorEmail.configureContent(title: "Cannot Send Email", body: "Please configure an email account on your (Mail App) device.")
            errorEmail.button?.isHidden = true
            SwiftMessages.show(view: errorEmail)
        }
    }
    
    // Implement the delegate method to handle the result of the email composition
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

