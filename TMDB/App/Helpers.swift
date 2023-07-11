//
//  Helpers.swift
//  TMDB
//
//  Created by Murat Akdal on 30.05.2023.
//

import UIKit

final class Helpers {
    func showBasicAlert(title: String, message: String, buttonTitle: String = "OK") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        alert.addAction(okAction)
        if #available (iOS 13.0, *) {
            guard let scene = UIApplication.shared.connectedScenes.first,
                  let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
                  let window = windowSceneDelegate.window else {
                return
            }
            window?.rootViewController?.present(alert, animated: true)
        } else {
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
        }
    }
    
    
    
}
