//
//  RegisterViewController.swift
//  pam-demo
//
//  Created by narongrit kanhanoi on 4/3/2564 BE.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet var emailField: UITextField!

    var onRegisterSuccess: ((String) -> Void)?

    override func viewDidLoad() {
        overrideUserInterfaceStyle = .light

        emailField.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(clickEmail))
        emailField.addGestureRecognizer(gesture)
    }

    @objc func clickEmail() {
        let alert = UIAlertController(title: "Register With Email", message: "Select an email you want to register.", preferredStyle: .actionSheet)

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

    @IBAction func clickRegister(_: Any) {
        let email = emailField.text ?? ""
        if email != "" {
            Pam.track(event: "register")
            dismiss(animated: true) {
                self.onRegisterSuccess?(email)
            }
        }
    }
}
