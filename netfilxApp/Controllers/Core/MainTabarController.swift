//
//  ViewController.swift
//  netfilxApp
//
//  Created by Nguyen  Khoa on 13/11/2022.
//

import UIKit

class MainTabarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
      // view.backgroundColor = .systemYellow
        
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: UpCommingViewController())
        let vc3 = UINavigationController(rootViewController: DowloadsViewController())
        let vc4 = UINavigationController(rootViewController: SearchViewController())
        
        //Tabar Image
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "play.circle")
        vc3.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        vc4.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        
        tabBar.tintColor = .label
        //Tabar Tittle
        vc1.title = "Home"
        vc2.title = "UpComing"
        vc3.title = "Dowload"
        vc4.title = "Search"
        
        
        setViewControllers([vc1,vc2,vc3,vc4], animated: true)
        
        
    }


}

