//
//  TMDBApi.swift
//  TMDB
//
//  Created by Murat Akdal on 5.04.2023.
//

import Foundation

protocol TMDBApiDelegate {
    func getMovies(movies: [Movie])
}



class TMDBApi {
    var delegate: TMDBApiDelegate?
    var movies: [Movie] = []
    let apiKey = "22a911354622cef33cde0747e1e8bec5"
    let apiUrl = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=22a911354622cef33cde0747e1e8bec5")
    
    
    func fetchMovies(){
        URLSession.shared.dataTask(with: apiUrl!) { data, URLResponse, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data else {return}
            do {
                let decoder = JSONDecoder()
                
                let response = try decoder.decode(MovieListResponse.self, from: data)
                
                self.movies = response.results ?? []
                DispatchQueue.main.async {
                    self.delegate?.getMovies(movies: self.movies)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
