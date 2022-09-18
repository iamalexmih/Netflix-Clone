//
//  ViewController.swift
//  Netflix Clone
//
//  Created by Алексей Попроцкий on 17.09.2022.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .blue
        
        let homeNavController = UINavigationController(rootViewController: HomeViewController())
        let upcomingNavController = UINavigationController(rootViewController: UpcomingViewController())
        let searchNavController = UINavigationController(rootViewController: SearchViewController())
        let downloadNavController = UINavigationController(rootViewController: DownloadViewController())
        
        
        homeNavController.tabBarItem.image = UIImage(systemName: "house")
        upcomingNavController.tabBarItem.image = UIImage(systemName: "play.circle")
        searchNavController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        downloadNavController.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        
        homeNavController.title = "Home"
        upcomingNavController.title = "Coming Soon"
        searchNavController.title = "Top Search"
        downloadNavController.title = "Download"
        
        tabBar.tintColor = .label
        
        setViewControllers([
            homeNavController,
            upcomingNavController,
            searchNavController,
            downloadNavController
        ], animated: true)
    }
}

