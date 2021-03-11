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
        
        setupPamPushNotif()
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

    func setupPamPushNotif() {
        Pam.listen("onPushNotification") { noti in
            if let noti = PamNoti.create(noti: noti) {
                self.openNoti(noti: noti)
            }
        }
    }
    
    func openNoti(noti: PamNoti) {
        
        guard let url = noti.url else {return}
        
        if let urlComponents = URLComponents(string: url) {
            if(urlComponents.host == "product") {
                let params = urlComponents.extractQueryParams()
                guard let productID = params["id"] else {return}
                guard let product = MockAPI.main.findProduct(id: productID) else {return}
                guard let vc = self.storyboard?.instantiateViewController(identifier: "ProductDetailViewController") as? ProductDetailViewController else {return}
                vc.setProduct(product: product)
                
                noti.markAsRead()//Mark Noti as read.
                self.navigationController?.pushViewController(vc, animated: true)
            }
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
    
    override func viewDidAppear(_ animated: Bool) {
        Pam.askNotificationPermission(mediaAlias: "ios-noti")
        Pam.appReady()
    }
}

extension URLComponents{
    func extractQueryParams() -> [String:String] {
        var params:[String:String] = [:]
        self.queryItems?.forEach {
            params[$0.name] = $0.value
        }
        return params
    }
}
