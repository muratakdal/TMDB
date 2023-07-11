//
//  SingleButtonTableViewCell.swift
//  TMDB
//
//  Created by Murat Akdal on 12.05.2023.
//

import UIKit

class SingleButtonTableViewCell: UITableViewCell {
    
        
    @IBOutlet weak var buttonLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func setupUI() {
        buttonLabel.layer.masksToBounds = true
        buttonLabel.layer.cornerRadius = 48
    }
}
