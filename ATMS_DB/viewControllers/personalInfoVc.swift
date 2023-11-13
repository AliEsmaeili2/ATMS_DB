//
//  TicketVc.swift
//  ATMS_DB
//
//  Created by Ali Esmaeili on 11/6/23.
//

import UIKit
import DropDown
import SkyFloatingLabelTextField

class personalInfoVc: UIViewController {
    
    @IBOutlet weak var fullName: SkyFloatingLabelTextField!
    @IBOutlet weak var nationalCode: SkyFloatingLabelTextField!
    @IBOutlet weak var phone: SkyFloatingLabelTextField!
    @IBOutlet weak var BirthDayPicker: UIDatePicker!
    
    @IBOutlet weak var DDView: UIView!
    @IBOutlet weak var DDLabel: UILabel!
    
    let dropDown = DropDown()
    let genderArray = [" Male", " Female"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DDLabel.text = " Select Gender 🔽"
        
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
        //    DropDown.appearance().selectionBackgroundColor = UIColor.systemGray6
        DropDown.appearance().cornerRadius = 2
    }
    
    
    @IBAction func DDButton(_ sender: Any) {
        
        dropDown.show()
    }
    
}
