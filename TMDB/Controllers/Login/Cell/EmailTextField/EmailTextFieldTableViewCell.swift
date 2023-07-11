//
//  TextFieldTableViewCell.swift
//  TMDB
//
//  Created by Murat Akdal on 31.03.2023.
//

import UIKit
import Firebase

protocol EmailTextFieldTableViewCellDelegate {
    
    func getEmailText(text:String)
}

class EmailTextFieldTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    var delegate :EmailTextFieldTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func bind(){
        
        emailTextField.delegate = self
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.getEmailText(text: textField.text ?? "")
    }
    
    private func setupUI() {
        emailTextField.layer.cornerRadius = 12
        emailTextField.layer.masksToBounds = true
        emailTextField.layer.shadowColor = UIColor.black.cgColor
        emailTextField.layer.shadowOffset = CGSize(width: 0, height: 2)
        emailTextField.layer.shadowOpacity = 0.8
    }
}
