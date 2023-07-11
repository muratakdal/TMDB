//
//  MainPageViewController.swift
//  TMDB
//
//  Created by Murat Akdal on 30.03.2023.
//

import UIKit
import Firebase
import Kingfisher

class MainPageViewController: UIViewController, TMDBApiDelegate {
    var movies: [Movie]?
    var filter: [Movie]?
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.registerTableViewCells()
        
        let api = TMDBApi()
        api.delegate = self
        api.fetchMovies()
        
        self.searchBar.delegate = self
                
    }
    
    func getMovies(movies: [Movie]) {
        self.movies = movies
        self.filter = movies
        if !movies.isEmpty {
            
            tableView.reloadData()
        }
    }
    
    func registerTableViewCells(){
        self.tableView.register(UINib(nibName: "FilmsTableViewCell", bundle: nil), forCellReuseIdentifier: "FilmsTableViewCell")
    }
}

extension MainPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filter?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            if let filmCell = tableView.dequeueReusableCell(withIdentifier: "FilmsTableViewCell") as? FilmsTableViewCell {
                let movie = filter?[indexPath.row]
                let path = URL(string: "https://image.tmdb.org/t/p/original\(filter?[indexPath.row].posterPath ?? "")")
                let inputFormatter = DateFormatter()
                inputFormatter.dateFormat = "YYYY-MM-dd"
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = "MMM d, yyy"
                let date = inputFormatter.date(from: filter?[indexPath.row].releaseDate ?? "1970-01-01")
                let dateString = outputFormatter.string(from: date!)
                filmCell.filmNameLabel.text = movie?.title
                filmCell.filmInfoLabel.text = dateString
                filmCell.filmImage.kf.setImage(with: path)
                return filmCell
            } else {
                return UITableViewCell()
            }
    }
    
    /*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 48
        case 1:
            return 120
        default:
            return 16
        }
    }*/
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailsPage = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FilmDetailsVC") as? FilmDetailsViewController
        detailsPage?.movie = filter?[indexPath.row]
        self.navigationController?.pushViewController(detailsPage!, animated: true)
    }
}


extension MainPageViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        textDidChange(text: searchText)
    }
    
    func textDidChange(text: String) {
        let lowercaseText = text.lowercased()
        filter = lowercaseText.isEmpty ? movies : movies?.filter { return $0.title?.lowercased().contains(lowercaseText) ?? false }
        tableView.reloadData()
    }
}
