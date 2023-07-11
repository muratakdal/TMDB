//
//  ButtonsTableViewCell.swift
//  TMDB
//
//  Created by Murat Akdal on 31.03.2023.
//

import UIKit
import Firebase

protocol ButtonsTableViewCellDelegate {
    func buttonClicked()
}

class ButtonsTableViewCell: UITableViewCell {
        
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupUI() {
        signInButton.layer.borderColor = UIColor.systemGreen.cgColor
        signUpButton.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
}
