//
//  ProductsListViewController.swift
//  pam-demo
//
//  Created by narongrit kanhanoi on 4/3/2564 BE.
//

import UIKit

class ProductsListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        print("ProductsListViewController")
        overrideUserInterfaceStyle = .light
        navigationItem.title = "boodaBEST"
//        tabBarItem.title = "Home"
//        tabBarItem.image = UIImage(named: "home_icon")
        
        setLoginBarItem()
    }
    
    func setLoginBarItem() {
        let loginItem = UIImageView(image: UIImage(named: "profile1"))
        loginItem.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let loginButton = UIBarButtonItem(customView: loginItem)
        navigationItem.rightBarButtonItems = [loginButton]
    }
    
    
    
}
