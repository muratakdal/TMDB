//
//  ButtonTableViewCell.swift
//  TMDB
//
//  Created by Murat Akdal on 18.07.2023.
//

import UIKit

protocol ButtonTableViewCellDelegate: AnyObject {
    func saveButtonTapped()
    func denyButtonTapped()
}


class ButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var denyButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    
    weak var delegate: ButtonTableViewCellDelegate?
    
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        delegate?.saveButtonTapped()
    }
    
    @IBAction func denyButtonClicked(_ sender: Any) {
        delegate?.denyButtonTapped()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
