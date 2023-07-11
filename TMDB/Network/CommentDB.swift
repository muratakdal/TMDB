//
//  CommentDB.swift
//  TMDB
//
//  Created by Murat Akdal on 24.05.2023.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

protocol CommentDBDelegate {
    func getComments(reviews: [Review])
}

class CommentDB {
    var delegate: CommentDBDelegate?
    var databaseRef: DatabaseReference!
    var reviews: [Review] = []
    let dbUrl = "https://tmdb-e5fe1-default-rtdb.europe-west1.firebasedatabase.app"
    
//    func read<T: AnyObject>(endpoint: String, completion: @escaping (T?, Error?) -> Void) {
//        databaseRef.child(endpoint).getData(completion:  { error, snapshot in
//            guard error == nil else {
//                completion(nil, error)
//                return
//            }
//
//            if let value = snapshot?.value as? T {
//                completion(value, nil)
//            } else {
//                completion(nil, nil)
//            }
//        })
//    }
}
