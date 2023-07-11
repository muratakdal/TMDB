//
//  AlertViewController.swift
//  TMDB
//
//  Created by Murat Akdal on 10.05.2023.
//

import UIKit

protocol AlertViewDelegate: AnyObject {
    func textDidChange(text: String)
    func starTapped(rating: Int)
}

class AlertViewController: UIViewController {
    weak var delegate: AlertViewDelegate?
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    @IBOutlet weak var commentTextfield: UITextField!
    
    var doneButtonClickedHandler: (() -> Void)?
    var starList: [UIImageView] = []
    var rating: Int = 0
    
    
    
    init(){
        super.init(nibName: "AlertViewController", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    @IBAction func doneAction(_ sender: UIButton) {
        doneButtonClickedHandler?()
        hide()
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        hide()
    }
    
    func setUI() {
        self.view.backgroundColor = .clear
        self.backView.backgroundColor = UIColor(named: "tmdbGreen")?.withAlphaComponent(0.7)
        self.backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hide)))
        self.backView.isUserInteractionEnabled = true
        self.backView.alpha = 0
        
        self.contentView.alpha = 0
        self.contentView.layer.cornerRadius = 12
        self.contentView.layer.masksToBounds = true
        
        self.commentTextfield.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        
        starList.append(star1)
        starList.append(star2)
        starList.append(star3)
        starList.append(star4)
        starList.append(star5)
        
        for item in starList {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(starTapped(_:)))
            item.addGestureRecognizer(tapGesture)
            item.isUserInteractionEnabled = true
        }
    }
    
    func appear(delegate: AlertViewDelegate, sender: UIViewController, doneButtonClicked: @escaping (() -> Void)) {
        self.delegate = delegate
        self.doneButtonClickedHandler = doneButtonClicked
        sender.present(self, animated: false) {
            self.show()
        }
    }
    
    private func show() {
        UIView.animate(withDuration: 1, delay: 0.1) {
            self.backView.alpha = 1
            self.contentView.alpha = 1
        }
    }
    
    @objc func hide() {
        UIView.animate(withDuration: 1, delay: 0.0, options: .curveEaseOut) {
            self.backView.alpha = 0
            self.contentView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
            self.removeFromParent()
        }
    }
    
    func rateStars(_ rating: Int) {
        
        for item in starList {
            if item.tag <= rating {
                item.image = UIImage(systemName: "star.fill")
            } else {
                item.image = UIImage(systemName: "star")
            }
        }
    }
    
    @objc private func starTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedStar = sender.view as? UIImageView else { return }
        
        rating = tappedStar.tag
        rateStars(rating)
        delegate?.starTapped(rating: rating)
    }
    
    @objc private func textDidChange(_ sender: UITextField) {
        delegate?.textDidChange(text: sender.text ?? "")
    }
}
