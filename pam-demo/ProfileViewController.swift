//
//  ProfileViewController.swift
//  pam-demo
//
//  Created by narongrit kanhanoi on 4/3/2564 BE.
//

import UIKit

class ProfileViewController: UIViewController{
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileEmail: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        overrideUserInterfaceStyle = .light
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let user = AppData.main.loginUser {
            profileImage.image = UIImage(named:  user.profileImage + "_big")
            profileName.text = user.name
            profileEmail.text = user.email
            loginButton.setTitle("Logout", for: .normal)
        }else{
            loginButton.setTitle("Login", for: .normal)
            profileName.text = "No login"
            profileEmail.text = ""
        }
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
    
    
    @IBAction func clickLogout(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(identifier: "LoginViewController") as? LoginViewController {
            
            Pam.userLogout()
            navigationController?.setViewControllers([vc], animated: true)
        }
    }
    
}
