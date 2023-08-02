//
//  ProfileViewController.swift
//  TMDB
//
//  Created by Murat Akdal on 10.05.2023.
//

import UIKit
import Firebase
import AlamofireImage
import FirebaseStorage

class ProfileViewController: UIViewController {
    
    private let activityIndicator: UIActivityIndicatorView = {
            let indicator = UIActivityIndicatorView(style: .large)
            indicator.color = UIColor(named: "tmdbGreen")
            indicator.hidesWhenStopped = true
            return indicator
        }()
    
    let ppRef = Storage.storage().reference()
    
    var isProfileEditing = false
    var imagePicker: UIImagePickerController!
    var editedName: String?
    var profilePhotoURL: String?
    var originalImage: UIImage?
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        registerTableViewCells()
        
        let editButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(editButtonPressed))
        editButton.tintColor = UIColor(named: "tmdbGreen")
        navigationItem.rightBarButtonItem = editButton
        
        readUserNameFromFirestore { name, error in
            if let error = error {
                print("Firestore'dan okuma hatası: \(error.localizedDescription)")
                return
            }
            
            if let name = name {
                self.editedName = name
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print("Firestore'da kullanıcının adı bulunamadı.")
            }
        }
        
        loadImageFromFirebase()
        
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        
    }
    
    @objc func selectImage() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .savedPhotosAlbum
        self.present(imagePicker, animated: true)
    }
    
    @objc private func editButtonPressed() {
        isProfileEditing = !isProfileEditing
        tableView.reloadData()
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 140
        default:
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 70
        default:
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if isProfileEditing {
                if let ppCell = tableView.dequeueReusableCell(withIdentifier: "ProfilePhotoTableViewCell") as? ProfilePhotoTableViewCell {
                    ppCell.isUserInteractionEnabled = true
                    let pencilCircle = UIImage(systemName:"pencil.circle")
                    ppCell.ppImage.image = originalImage ?? pencilCircle
                    let tap = UITapGestureRecognizer(target: self, action: #selector(selectImage))
                    ppCell.addGestureRecognizer(tap)
                    return ppCell
                }
            } else {
                if let ppCell = tableView.dequeueReusableCell(withIdentifier: "ProfilePhotoTableViewCell") as? ProfilePhotoTableViewCell {
                    ppCell.isUserInteractionEnabled = false
                    let personCircle = UIImage(systemName:"person.circle")
                    ppCell.ppImage.image = originalImage ?? personCircle
                    return ppCell
                }
            }
        case 1:
            if isProfileEditing {
                if let userNameCell = tableView.dequeueReusableCell(withIdentifier: "KeyValueTableViewCell") as? KeyValueTableViewCell {
                    userNameCell.bind()
                    userNameCell.delegate = self
                    userNameCell.keyLabel.text = "Name: "
                    userNameCell.valueTF.isHidden = false
                    userNameCell.valueTF.text = editedName
                    userNameCell.valueTF.placeholder = editedName
                    userNameCell.valueLabel.isHidden = true
                    
                    return userNameCell
                }
            } else {
                if let userNameCell = tableView.dequeueReusableCell(withIdentifier: "KeyValueTableViewCell") as? KeyValueTableViewCell {
                    userNameCell.keyLabel.text = "Name: "
                    userNameCell.valueLabel.text = editedName
                    userNameCell.valueTF.isHidden = true
                    userNameCell.valueLabel.isHidden = false
                    
                    return userNameCell
                }
            }
        case 2:
            if let userEmailCell = tableView.dequeueReusableCell(withIdentifier: "KeyValueTableViewCell") as? KeyValueTableViewCell {
                userEmailCell.isUserInteractionEnabled = false
                userEmailCell.keyLabel.text = "User Email: "
                userEmailCell.valueLabel.text = Auth.auth().currentUser?.email
                userEmailCell.valueTF.isHidden = true
                return userEmailCell
            }
        case 3:
            if isProfileEditing {
                if let logOutButtonCell = tableView.dequeueReusableCell(withIdentifier: "SingleButtonTableViewCell") as? SingleButtonTableViewCell {
                    logOutButtonCell.isHidden = true
                    return logOutButtonCell
                }
            } else {
                if let logOutButtonCell = tableView.dequeueReusableCell(withIdentifier: "SingleButtonTableViewCell") as? SingleButtonTableViewCell {
                    logOutButtonCell.isHidden = false
                    logOutButtonCell.buttonLabel.text = "Sign Out"
                    return logOutButtonCell
                }
            }
        case 4:
            if isProfileEditing {
                if let buttonCell = tableView.dequeueReusableCell(withIdentifier: "ButtonTableViewCell") as? ButtonTableViewCell {
                    buttonCell.saveButton.isHidden = false
                    buttonCell.denyButton.isHidden = false
                    buttonCell.delegate = self
                    return buttonCell
                }
            } else {
                if let buttonCell = tableView.dequeueReusableCell(withIdentifier: "ButtonTableViewCell") as? ButtonTableViewCell {
                    buttonCell.saveButton.isHidden = true
                    buttonCell.denyButton.isHidden = true
                    return buttonCell
                }
            }
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 3 {
            logOut()
            print("Log out succesfully.")
        }
    }
    
    func registerTableViewCells(){
        self.tableView.register(UINib(nibName: "ProfilePhotoTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfilePhotoTableViewCell")
        self.tableView.register(UINib(nibName: "KeyValueTableViewCell", bundle: nil), forCellReuseIdentifier: "KeyValueTableViewCell")
        self.tableView.register(UINib(nibName: "SingleButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "SingleButtonTableViewCell")
        self.tableView.register(UINib(nibName: "ButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "ButtonTableViewCell")
    }
    
    private func editSaveButtonClicked() {
        if let originalImage = originalImage {
            uploadImageToFirebase(originalImage)
        }
        
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProfilePhotoTableViewCell {
            cell.ppImage?.image = originalImage
        }
        
        if let editedName = editedName {
            saveNameToFirestore(name: editedName)
        }
        
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? KeyValueTableViewCell {
            if cell.valueTF.text != "" {
                isProfileEditing = false
                tableView.reloadData()
            } else {
                Helpers().showBasicAlert(title: "Notice", message: "Name field can not be blank.")
            }
        }
    }
    
    private func editCancelButtonClicked() {
        isProfileEditing = false
        tableView.reloadData()
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

extension ProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProfilePhotoTableViewCell {
                self.originalImage = originalImage
                cell.ppImage?.image = originalImage
            }
        }
        picker.dismiss(animated: true)
    }
    
    private func uploadImageToFirebase(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            return
        }
        let profilePhotoRef = ppRef.child("profile_photos/\(Auth.auth().currentUser!.uid).jpg")
        
        _ = profilePhotoRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading profile photo: \(error)")
                return
            }
            
            profilePhotoRef.downloadURL { url, error in
                if let downloadURL = url {
                    self.profilePhotoURL = downloadURL.absoluteString
                } else if let error = error {
                    print("Error getting profile photo download URL: \(error)")
                }
            }
        }
    }
    
    private func loadImageFromFirebase() {
        activityIndicator.startAnimating()
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let profilePhotoRef = ppRef.child("profile_photos/\(userId).jpg")
        
        profilePhotoRef.downloadURL { url, error in
            if let error = error {
                print("Error getting profile photo download URL: \(error)")
                return
            }
            
            guard let downloadURL = url else {
                return
            }
            
            let task = URLSession.shared.dataTask(with: downloadURL) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    let profileImage = UIImage(data: data)
                    self.originalImage = profileImage
                    self.tableView.reloadData()
                }
            }
            task.resume()
        }
        activityIndicator.stopAnimating()
    }
}

extension ProfileViewController: ButtonTableViewCellDelegate {
    func saveButtonTapped() {
        view.endEditing(true)
        editSaveButtonClicked()
    }
    
    func denyButtonTapped() {
        editCancelButtonClicked()
    }
}

extension ProfileViewController: KeyValueTableViewCellDelegate {
    func getValueText(text: String) {
        editedName = text
    }
}

extension ProfileViewController {
    func saveNameToFirestore(name: String) {
        if let userId = Auth.auth().currentUser?.uid {
            let firestoreDatabase = Firestore.firestore()
            
            let userDisplayNameRef = firestoreDatabase.collection("UserDisplayName").document("\(userId)")
            
            let userNameData: [String: Any] = [
                "name": name
            ]
            
            userDisplayNameRef.setData(userNameData) { error in
                if let error = error {
                    Helpers().showBasicAlert(title: "Notice", message: error.localizedDescription)
                } else {
                    print("Name saved to Firestore: \(name)")
                }
            }
        }
    }
    
    // TODO: this gonna be read from firestore function
    
    func readUserNameFromFirestore(completion: @escaping (String?, Error?) -> Void) {
        activityIndicator.startAnimating()
        if let userId = Auth.auth().currentUser?.uid {
            let firestoreDatabase = Firestore.firestore()
            
            let userDisplayNameRef = firestoreDatabase.collection("UserDisplayName").document("\(userId)")
            
            userDisplayNameRef.getDocument { document, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                if let document = document, document.exists {
                    if let name = document.data()?["name"] as? String {
                        completion(name, nil)
                    } else {
                        completion(nil, nil) // Kullanıcının ismi Firestore'da bulunamadı.
                    }
                } else {
                    completion(nil, nil) // Belirtilen döküman bulunamadı veya hata oluştu.
                }
            }
        } else {
            completion(nil, nil) // Kullanıcı oturum açmamış.
        }
        activityIndicator.stopAnimating()
    }
}



