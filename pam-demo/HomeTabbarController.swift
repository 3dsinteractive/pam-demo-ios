//
//  HomeTabbarController.swift
//  pam-demo
//
//  Created by narongrit kanhanoi on 4/3/2564 BE.
//

import UIKit

class HomeTabbarController: UITabBarController {
    var home: ProductsListViewController?
    var cart: ShoppingCartViewController?
    var profile: ProfileViewController?

    override func viewDidLoad() {
        overrideUserInterfaceStyle = .light

        var controller: [UIViewController] = []

        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)

        if let vc = storyBoard.instantiateViewController(identifier: "ProductsListViewController") as? ProductsListViewController {
            vc.initView()
            controller.append(vc)
            home = vc
        }

        if AppData.main.loginUser != nil {
            if let vc = storyBoard.instantiateViewController(identifier: "ShoppingCartViewController") as? ShoppingCartViewController {
                vc.initView()
                controller.append(vc)
                cart = vc
            }
        }

        if let vc = storyBoard.instantiateViewController(identifier: "ProfileViewController") as? ProfileViewController {
            vc.initView()
            controller.append(vc)
            profile = vc
        }

        viewControllers = controller

        NotificationCenter.default.addObserver(self, selector: #selector(cartChange), name: NSNotification.Name(rawValue: "cartChange"), object: nil)
    }

    @objc func cartChange() {
        let count = MockAPI.main.getCartCount()
        cart?.tabBarItem.badgeColor = UIColor.red
        if count < 1 {
            cart?.tabBarItem.badgeValue = nil
        } else {
            cart?.tabBarItem.badgeValue = "\(count)"
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
