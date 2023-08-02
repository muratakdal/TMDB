//
//  ProfilePhotoTableViewCell.swift
//  TMDB
//
//  Created by Murat Akdal on 11.07.2023.
//

import UIKit


protocol ProfilePhotoTableViewCellDelegate {
    
}

class ProfilePhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var ppImage: UIImageView!
    
    var delegate: ProfilePhotoTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    private func setupUI() {
        ppImage.layer.masksToBounds = true
        ppImage.layer.borderWidth = 3
        ppImage.layer.borderColor = UIColor(named: "tmdbGreen")?.cgColor
        ppImage.layer.cornerRadius = ppImage.frame.size.height / 2
    }

}
