//
//  HomeTabbarController.swift
//  pam-demo
//
//  Created by narongrit kanhanoi on 4/3/2564 BE.
//

import UIKit

class HomeTabbarController: UITabBarController {
    
    override func viewDidLoad() {
        overrideUserInterfaceStyle = .light
        
        var controller:[UIViewController] = []
        
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        if let home = storyBoard.instantiateViewController(identifier: "ProductsListViewController") as? ProductsListViewController {
            controller.append(home)
        }
        
        if let profile = storyBoard.instantiateViewController(identifier: "ProfileViewController") as? ProfileViewController {
            profile.initView()
            controller.append(profile)
        }
        
        viewControllers = controller
    }
}
