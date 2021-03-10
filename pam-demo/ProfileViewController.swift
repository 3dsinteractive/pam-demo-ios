//
//  ProfileViewController.swift
//  pam-demo
//
//  Created by narongrit kanhanoi on 4/3/2564 BE.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var profileName: UILabel!
    @IBOutlet var profileEmail: UILabel!
    @IBOutlet var loginButton: UIButton!

    override func viewDidLoad() {
        overrideUserInterfaceStyle = .light
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let user = AppData.main.loginUser {
            profileImage.image = UIImage(named: user.profileImage + "_big")
            profileName.text = user.name
            profileEmail.text = user.email
            loginButton.setTitle("Logout", for: .normal)
        } else {
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
        } else {
            tabBarItem.title = "Login"
            tabBarItem.image = UIImage(named: "no_login")?.withRenderingMode(.alwaysOriginal)
        }
    }

    @IBAction func clickLogout(_: Any) {
        if let vc = storyboard?.instantiateViewController(identifier: "LoginViewController") as? LoginViewController {
            
            let defaults = UserDefaults.standard
            defaults.removeObject(forKey: "login_user")
            defaults.synchronize()
            
            
            Pam.userLogout()
            navigationController?.setViewControllers([vc], animated: true)
        }
    }
}
