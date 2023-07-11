//
//  ProfileViewController.swift
//  TMDB
//
//  Created by Murat Akdal on 10.05.2023.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        registerTableViewCells()
        
        
    }
    
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let userEmailCell = tableView.dequeueReusableCell(withIdentifier: "KeyValueTableViewCell") as? KeyValueTableViewCell {
                
                userEmailCell.keyLabel.text = "User Email: "
                userEmailCell.valueLabel.text = Auth.auth().currentUser?.email
                
                return userEmailCell
            }
        case 1:
            if let logOutButtonCell = tableView.dequeueReusableCell(withIdentifier: "SingleButtonTableViewCell") as? SingleButtonTableViewCell {
                logOutButtonCell.buttonLabel.text = "Sign Out"
                return logOutButtonCell
            }
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            logOut()
            print("Log out succesfully.")
        }
    }
    
    
    func registerTableViewCells(){
        self.tableView.register(UINib(nibName: "KeyValueTableViewCell", bundle: nil), forCellReuseIdentifier: "KeyValueTableViewCell")
        self.tableView.register(UINib(nibName: "SingleButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "SingleButtonTableViewCell")
    }
    
    private func logOut(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            
            
            UserDefaults.standard.set(nil, forKey: "userEmail")
            UserDefaults.standard.set(nil, forKey: "userPassword")
            
            let board = UIStoryboard(name: "Main", bundle: nil)
            let mainPage = board.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
            mainPage.modalPresentationStyle = .fullScreen
            navigationController?.present(mainPage, animated: true)
            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
            }
    
    
}
