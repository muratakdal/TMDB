//
//  FilmOverviewTableViewCell.swift
//  TMDB
//
//  Created by Murat Akdal on 26.04.2023.
//

import UIKit

class FilmOverviewTableViewCell: UITableViewCell {

    @IBOutlet weak var filmTitleLabel: UILabel!
    @IBOutlet weak var filmOverviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
