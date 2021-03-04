//
//  ProfileViewController.swift
//  pam-demo
//
//  Created by narongrit kanhanoi on 4/3/2564 BE.
//

import UIKit

class ProfileViewController: UIViewController{
    
    override func viewDidLoad() {
        print("ProfileViewController")
        
        overrideUserInterfaceStyle = .light
    }
    
    func initView() {
        navigationItem.title = "boodaBEST"
        if let user = AppData.main.loginUser {
            tabBarItem.title = user.name
            tabBarItem.image = UIImage(named: user.profileImage)?.withRenderingMode(.alwaysOriginal)
        }else{
            tabBarItem.title = "Login"
            tabBarItem.image = UIImage(named: "no_login")?.withRenderingMode(.alwaysOriginal)
        }
    }
    
    
    
}
