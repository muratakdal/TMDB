//
//  FilmDetailsViewController.swift
//  TMDB
//
//  Created by Murat Akdal on 26.04.2023.
//

import UIKit
import Kingfisher
import Firebase
import FirebaseStorage

class FilmDetailsViewController: UIViewController{
    var movie: Movie?
    var review: Review?
    var commentText: String?
    var rating: Int?
    var databaseRef: DatabaseReference!
    var reviews: ReviewList?
    
    @IBOutlet weak var detailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Film Detail"
        self.detailTableView.delegate = self
        self.detailTableView.dataSource = self
        self.registerTableViewCells()
        readComments()
        let addCommentButton = UIBarButtonItem(image: UIImage(systemName: "quote.bubble.fill"), style: .plain, target: self, action: #selector(addButtonPressed))
        addCommentButton.tintColor = UIColor(named: "tmdbGreen")
        navigationItem.rightBarButtonItem = addCommentButton
    }
   
    func registerTableViewCells(){
        self.detailTableView.register(UINib(nibName: "FilmBackgroundTableViewCell", bundle: nil), forCellReuseIdentifier: "FilmBackgroundTableViewCell")
        self.detailTableView.register(UINib(nibName: "FilmOverviewTableViewCell", bundle: nil), forCellReuseIdentifier: "FilmOverviewTableViewCell")
        self.detailTableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentTableViewCell")
    }
    
    @objc private func addButtonPressed() {
        let alertView = AlertViewController()
        alertView.appear(delegate: self, sender: self) {
            guard let comment = self.commentText, !comment.isEmpty else {
                Helpers().showBasicAlert(title: "Notice",
                                         message: "Comment field cannot be left blank.")
                return
            }
            
            self.saveCommentToFirestore(comment: comment, star: self.rating ?? 0, userEmail: (Auth.auth().currentUser?.email)!)
        }
    }
    
    func saveCommentToFirestore(comment: String, star: Int, userEmail: String) {
        if let movieId = movie?.id {
            let firestoreDatabase = Firestore.firestore()
            
            let movieRef = firestoreDatabase.collection("Movies").document("\(movieId)")
            
            let commentRef = movieRef.collection("Comments").document()
            
            let commentData: [String: Any] = [
                "star": star,
                "useremail": userEmail,
                "comment": comment
            ]
            
            commentRef.setData(commentData) { error in
                if let error = error {
                    Helpers().showBasicAlert(title: "Notice", message: error.localizedDescription)
                } else {
                    print("Comment saved to Firestore")
                }
            }
        }
    }
    
    
    func readComments() {
        guard let movieId = movie?.id else {
            return
        }
        
        let firestoreDatabase = Firestore.firestore()
        
        let commentsRef = firestoreDatabase.collection("Movies").document("\(movieId)").collection("Comments")
        
        commentsRef.addSnapshotListener { snapshot, error in
            if let error = error {
                Helpers().showBasicAlert(title: "Notice", message: error.localizedDescription)
            } else {
                guard let documents = snapshot?.documents else {
                    print("No comments found")
                    return
                }
                self.reviews = ReviewList(results: [])
                
                for document in documents {
                    
                    if let userEmail = document.get("useremail") as? String, let comment = document.get("comment") as? String, let star = document.get("star") as? Int {
                        let review = Review(stars: star, comment: comment, userEmail: userEmail)
                        self.reviews?.results.append(review)
                    }
                }
                self.detailTableView.reloadData()
            }
        }
    }
}

extension FilmDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 2:
            return reviews?.results.count ?? 0
        default:
            return 1
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let imageCell = tableView.dequeueReusableCell(withIdentifier: "FilmBackgroundTableViewCell") as? FilmBackgroundTableViewCell {
                let path = URL(string: "https://image.tmdb.org/t/p/original\(movie?.backdropPath ?? "")")
                imageCell.filmImage.kf.setImage(with: path)
                return imageCell
            }
        case 1:
            if let overviewCell = tableView.dequeueReusableCell(withIdentifier: "FilmOverviewTableViewCell") as? FilmOverviewTableViewCell {
                overviewCell.filmTitleLabel.text = movie?.title
                overviewCell.filmOverviewLabel.text = movie?.overview
                return overviewCell
            }
        case 2:
            if let commentCell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as? CommentTableViewCell {
                commentCell.nameLabel.text = reviews?.results[indexPath.row].userEmail
                commentCell.commentLabel.text = reviews?.results[indexPath.row].comment
                let starRating = reviews?.results[indexPath.row].stars ?? 0
                commentCell.setStarRating(starRating)
                return commentCell
            }
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    
    
}

extension FilmDetailsViewController: AlertViewDelegate {
    func textDidChange(text: String) {
        self.commentText = text
    }
    
    func starTapped(rating: Int) {
        self.rating = rating
    }
}
