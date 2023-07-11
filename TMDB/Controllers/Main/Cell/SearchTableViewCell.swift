//
//  SearchTableViewCell.swift
//  TMDB
//
//  Created by Murat Akdal on 25.04.2023.
//

import UIKit

protocol SearchTableViewCellDelegate: AnyObject {
    func textDidChange(text: String)
}

class SearchTableViewCell: UITableViewCell, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    var delegate: SearchTableViewCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        searchBar.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate.textDidChange(text: searchText)
    }
    
}
