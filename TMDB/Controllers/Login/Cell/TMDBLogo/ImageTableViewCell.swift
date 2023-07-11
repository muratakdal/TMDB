//
//  CellImageTableViewCell.swift
//  TMDB
//
//  Created by Murat Akdal on 31.03.2023.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var imageCell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
