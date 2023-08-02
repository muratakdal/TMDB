//
//  TabbarViewController.swift
//  TMDB
//
//  Created by Murat Akdal on 10.05.2023.
//

import UIKit

class TabbarViewController: UITabBarController {
    
    var profile : ProfileViewController? = nil
    var main : MainPageViewController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarController()
        UITabBar.appearance().barTintColor = UIColor(named: "tmdbGreen")
        UITabBar.appearance().tintColor = UIColor(named: "tmdbDarkBlue")
        UITabBar.appearance().unselectedItemTintColor = .white
    }
    
    private func setupTabBarController() {
        
        
        profile = ProfileViewController()
        
        //Top Rated View Tab
        main = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainPageViewController") as? MainPageViewController
        let vc1 = setupViewController(with: main!,
                                      tabBarTitle: "Top Rated Films",
                                      tabBarImage: UIImage(systemName: "list.star")!,
                                      tabBarSelectedImage: nil)
        //Profile View Tab
        let vc2 = setupViewController(with: profile!,
                                      tabBarTitle: "Profile",
                                      tabBarImage: UIImage(systemName: "person.fill")!,
                                      tabBarSelectedImage: nil)
        viewControllers = [vc1, vc2]
    }
    
    private func setupViewController(with viewController: UIViewController, tabBarTitle: String, tabBarImage: UIImage, tabBarSelectedImage: UIImage?) -> UINavigationController {
        viewController.tabBarItem = UITabBarItem(title: tabBarTitle, image: tabBarImage, selectedImage: tabBarSelectedImage)
        return UINavigationController(rootViewController: viewController)

    }
}
