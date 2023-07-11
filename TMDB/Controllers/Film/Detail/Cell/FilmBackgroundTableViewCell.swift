//
//  FilmBackgroundTableViewCell.swift
//  TMDB
//
//  Created by Murat Akdal on 26.04.2023.
//

import UIKit

class FilmBackgroundTableViewCell: UITableViewCell {

    @IBOutlet weak var filmImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupUI() {
        filmImage.layer.masksToBounds = true
        filmImage.layer.cornerRadius = 12
    }
}
