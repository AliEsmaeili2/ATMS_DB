//
//  TextFieldCustomize.swift
//  ATMS_DB
//
//  Created by Ali Esmaeili on 12/31/23.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField

// MARK: - EmployeeInfoVc
extension EmployeeInfoVc {
    
    @objc func nameDidChange(_ textfield: UITextField) {
        
        if let text = textfield.text {
            if let floatingLabelTextField = fullName {
                if(text.count < 6) {
                    floatingLabelTextField.errorMessage = "Invalid Full Name"
                }
                else {
                    // The error message will only disappear when we reset it to nil or empty string
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
    }
    
    @objc func IDDidChange(_ textfield: UITextField) {
        
        if let id = textfield.text {
            if let floatingLabelTextField = employeeID {
                if(id.count > 3) {
                    floatingLabelTextField.errorMessage = "Invalid ID:(Maximum 3 & must be Number)"
                }
                else {
                    // The error message will only disappear when we reset it to nil or empty string
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
    }
    
    func fullnameTF() {
        
        fullName.autocorrectionType = .no
        fullName.autocapitalizationType = .none
        fullName.spellCheckingType = .no
    }
}

// MARK: - personalInfoVc
extension personalInfoVc: UITextFieldDelegate {
    
    @objc func nameDidChange(_ textfield: UITextField) {
        
        if let text = textfield.text {
            
            if let floatingLabelTextField = fullName {
                if(text.count < 6) {
                    floatingLabelTextField.errorMessage = "Invalid Full Name"
                    // saveButton.isHidden = true
                }
                else {
                    // The error message will only disappear when we reset it to nil or empty string
                    floatingLabelTextField.errorMessage = ""
                    
                    // saveButton.isHidden = false
                }
            }
        }
    }
    
    func fullnameTF() {
        
        fullName.autocorrectionType = .no
        fullName.autocapitalizationType = .none
        fullName.spellCheckingType = .no
    }
    
}
