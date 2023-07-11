//
//  TableViewController.swift
//  TMDB
//
//  Created by Murat Akdal on 31.03.2023.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EmailTextFieldTableViewCellDelegate, PasswordTextFieldTableViewCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var emailText =  ""
    var passwordText = ""
    
    func getEmailText(text: String) {
        emailText = text
    }
    func getPasswordText(text: String) {
        passwordText = text
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
                
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.registerTableViewCells()
        
        
      

    }
    
    @objc func reloadTable() {
        // Logout işlemleri
        
         emailText =  ""
         passwordText = ""
        tableView.reloadData()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let imageCell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell") as? ImageTableViewCell {
                return imageCell
            }
        case 1:
            if let emailCell = tableView.dequeueReusableCell(withIdentifier: "EmailTextFieldTableViewCell") as? EmailTextFieldTableViewCell {
                emailCell.delegate = self
                emailCell.bind()
                emailCell.emailTextField.text = Auth.auth().currentUser?.email

                return emailCell
            }
        case 2:
            if let passwordCell = tableView.dequeueReusableCell(withIdentifier: "PasswordTextFieldTableViewCell") as? PasswordTextFieldTableViewCell {
                passwordCell.delegate = self
                passwordCell.bind()
                passwordCell.passwordTextField.text = passwordText
                return passwordCell
            }
        case 3:
            if let buttonsCell = tableView.dequeueReusableCell(withIdentifier: "ButtonsTableViewCell") as? ButtonsTableViewCell {
                buttonsCell.signInButton.addTarget(self, action: #selector(signInButtonAction(_:)), for: .touchUpInside)
                buttonsCell.signUpButton.addTarget(self, action: #selector(signUpButtonAction(_:)), for: .touchUpInside)
                return buttonsCell
            }
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    
    
    @objc func signInButtonAction(_ sender: UIButton) {
        // Disable the button
        sender.isEnabled = false
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = sender.center
        sender.superview?.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        dismissKeyboard()
        if emailText != "" && passwordText != "" {
            Auth.auth().signIn(withEmail: emailText , password: passwordText ) { authdata, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error!", messageInput: error!.localizedDescription)
                } else {
                    UserDefaults.standard.set(self.passwordText, forKey: "userPassword")
                    let tabbarVC = TabbarViewController()
                    tabbarVC.modalPresentationStyle = .fullScreen
                    self.show(tabbarVC, sender: nil)
                }
                // Enable the button
                sender.isEnabled = true
                // Remove the activity indicator
                activityIndicator.stopAnimating()
            }
        } else {
            makeAlert(titleInput: "Error", messageInput: "Lütfen bir kullanıcı adı ve şifre giriniz.")
            sender.isEnabled = true
            activityIndicator.stopAnimating()
        }
    }

    
    @objc func signUpButtonAction(_ sender: UIButton) {
        sender.isEnabled = false
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = sender.center
        sender.superview?.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        dismissKeyboard()
        if emailText != "" && passwordText != "" {
            Auth.auth().createUser(withEmail: emailText, password: passwordText) { authdata, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error!", messageInput: error!.localizedDescription)
                } else {
                    let tabbarVC = TabbarViewController()
                    tabbarVC.modalPresentationStyle = .fullScreen
                    self.show(tabbarVC, sender: nil)
                }
                sender.isEnabled = true
                activityIndicator.stopAnimating()
            }
        } else {
            makeAlert(titleInput: "Error!", messageInput: "Lütfen bir kullanıcı adı ve şifre giriniz.")
            sender.isEnabled = true
            activityIndicator.stopAnimating()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 80
        case 1:
            return 48
        case 2:
            return 48
        case 3:
            return 96
        default:
            return 16
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        case 1:
            return 72
        case 3:
            return 72
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    
    private func registerTableViewCells() {
        
        self.tableView.register(UINib(nibName: "ImageTableViewCell",
                                      bundle: nil),
                                forCellReuseIdentifier: "ImageTableViewCell")
        self.tableView.register(UINib(nibName: "EmailTextFieldTableViewCell",
                                      bundle: nil),
                                forCellReuseIdentifier: "EmailTextFieldTableViewCell")
        self.tableView.register(UINib(nibName: "PasswordTextFieldTableViewCell",
                                      bundle: nil),
                                forCellReuseIdentifier: "PasswordTextFieldTableViewCell")
        self.tableView.register(UINib(nibName: "ButtonsTableViewCell",
                                      bundle: nil),
                                forCellReuseIdentifier: "ButtonsTableViewCell")
    }
    
    func makeAlert(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
