//
//  PasswordTextFieldTableViewCell.swift
//  TMDB
//
//  Created by Murat Akdal on 31.03.2023.
//

import UIKit
import Firebase

protocol PasswordTextFieldTableViewCellDelegate {
    func getPasswordText(text: String)
}

class PasswordTextFieldTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    var delegate: PasswordTextFieldTableViewCellDelegate?
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func bind(){
        passwordTextField.delegate = self
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else {
            return true
        }
        
        print("current text: " + currentText)
        
        // Create the new text by replacing the characters that will be changed
        //let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // Validate the updated text - for example, it must be no longer than a certain length
        if currentText.count < 20 {
            // The updated text is valid, pass it to the delegate
            //delegate?.getPasswordText(text: updatedText)
            return true
        } else {
            // The updated text is not valid, don't allow the change
            return false
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let currentText = textField.text else {
            return
        }
        print("end editing: " + (textField.text ?? ""))
        delegate?.getPasswordText(text: currentText)
    }
    
    private func setupUI() {
        passwordTextField.layer.cornerRadius = 12
        passwordTextField.layer.masksToBounds = true
        passwordTextField.layer.shadowColor = UIColor.black.cgColor
        passwordTextField.layer.shadowOffset = CGSize(width: 0, height: 2)
        passwordTextField.layer.shadowOpacity = 0.8
    }
}
