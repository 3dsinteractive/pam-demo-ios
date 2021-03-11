//
//  LoginViewController.swift
//  pam-demo
//
//  Created by narongrit kanhanoi on 2/3/2564 BE.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet var emailField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        overrideUserInterfaceStyle = .light

        emailField.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(clickEmail))
        emailField.addGestureRecognizer(gesture)
    
        if let savedPerson = UserDefaults.standard.object(forKey: "login_user") as? Data {
            let decoder = JSONDecoder()
            if let user = try? decoder.decode(UserModel.self, from: savedPerson) {
                AppData.main.loginUser = user
                gotoHome()
            }
        }
        
    }

    @objc func clickEmail() {
        let alert = UIAlertController(title: "Login With Email", message: "Select an email you want to login.", preferredStyle: .actionSheet)

        let mail1 = UIAlertAction(title: "a@a.com", style: .default, handler: { _ in
            self.emailField.text = "a@a.com"
        })

        let mail2 = UIAlertAction(title: "b@b.com", style: .default, handler: { _ in
            self.emailField.text = "b@b.com"
        })

        let mail3 = UIAlertAction(title: "c@c.com", style: .default, handler: { _ in
            self.emailField.text = "c@c.com"
        })

        alert.addAction(mail1)
        alert.addAction(mail2)
        alert.addAction(mail3)

        present(alert, animated: true, completion: nil)
    }

    override func viewDidAppear(_: Bool) {
        Pam.appReady()
        Pam.track(event: "page_view", payload: ["page_url":"boodabest://login", "page_title": "Login"])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func doLogin(email: String) {
        if let user = MockAPI.main.login(email: email) {
            
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(user) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: "login_user")
                defaults.synchronize()
            }
            
            Pam.userLogin(custID: user.custID)
            AppData.main.loginUser = user
            gotoHome()
        }
    }

    func gotoHome() {
        let tabViewController = HomeTabbarController()
        navigationController?.setViewControllers([tabViewController], animated: true)
    }

    @IBAction func clickLogin(_: Any) {
        let email = emailField.text ?? ""
        if email != "" {
            doLogin(email: email)
        }
    }

    @IBAction func clickSkipLogin(_: Any) {
        gotoHome()
    }

    @IBAction func clickRegister(_: Any) {
        if let viewController = storyboard?.instantiateViewController(identifier: "RegisterViewController") as? RegisterViewController {
            present(viewController, animated: true)
            viewController.onRegisterSuccess = { email in
                self.doLogin(email: email)
            }
        }
    }
}
