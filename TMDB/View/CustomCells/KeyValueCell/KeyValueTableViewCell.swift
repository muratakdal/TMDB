//
//  KeyValueTableViewCell.swift
//  TMDB
//
//  Created by Murat Akdal on 12.05.2023.
//

import UIKit

protocol KeyValueTableViewCellDelegate {
    func getValueText(text: String)
}

class KeyValueTableViewCell: UITableViewCell, UITextFieldDelegate {
    var delegate: KeyValueTableViewCellDelegate?

    @IBOutlet weak var keyLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var valueTF: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.getValueText(text: textField.text ?? "Error")
    }
    
    func bind(){
        valueTF.delegate = self
    }
    
}
