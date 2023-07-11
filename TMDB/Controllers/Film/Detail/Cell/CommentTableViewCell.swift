//
//  CommentTableViewCell.swift
//  TMDB
//
//  Created by Murat Akdal on 9.05.2023.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var mainView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
    
    func setStarRating(_ rating: Int) {
        let starList: [UIImageView] = [star1, star2, star3, star4, star5]
        
        for item in starList {
            if item.tag <= rating {
                item.image = UIImage(systemName: "star.fill")
            } else {
                item.image = UIImage(systemName: "star")
            }
        }

    }


    private func setUI() {
        mainView.layer.cornerRadius = 12
        mainView.layer.masksToBounds = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
