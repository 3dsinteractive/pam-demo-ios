//
//  PaymentViewColtroller.swift
//  pam-demo
//
//  Created by narongrit kanhanoi on 5/3/2564 BE.
//

import UIKit

class PaymentViewColtroller: UIViewController {
    @IBOutlet var method1Image: UIImageView!
    @IBOutlet var method2Image: UIImageView!
    @IBOutlet var method1Radio: UIImageView!
    @IBOutlet var method2Radio: UIImageView!

    override func viewDidLoad() {
        overrideUserInterfaceStyle = .dark

        method1Image.isUserInteractionEnabled = true
        method2Image.isUserInteractionEnabled = true
        method1Radio.isUserInteractionEnabled = true
        method2Radio.isUserInteractionEnabled = true

        var ges1 = UITapGestureRecognizer(target: self, action: #selector(clickMethod1))
        method1Image.addGestureRecognizer(ges1)

        ges1 = UITapGestureRecognizer(target: self, action: #selector(clickMethod1))
        method1Radio.addGestureRecognizer(ges1)

        var ges2 = UITapGestureRecognizer(target: self, action: #selector(clickMethod2))
        method2Image.addGestureRecognizer(ges2)

        ges2 = UITapGestureRecognizer(target: self, action: #selector(clickMethod2))
        method2Radio.addGestureRecognizer(ges2)
    }

    @objc func clickMethod1() {
        method1Radio.image = UIImage(named: "radio_checked")
        method2Radio.image = UIImage(named: "radio")
    }

    @objc func clickMethod2() {
        method1Radio.image = UIImage(named: "radio")
        method2Radio.image = UIImage(named: "radio_checked")
    }

    @IBAction func clickPay(_: Any) {
        trackPurchase()
        MockAPI.main.pay()

        let alert = UIAlertController(title: "Success!", message: "Thankyou for your order.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { _ in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cartChange"), object: nil)
            self.dismiss(animated: true)
        }))

        present(alert, animated: true)
    }

    func trackPurchase() {
        let cart = MockAPI.main.getCart()
        let productIDList = cart.map {
            $0.productID
        }.reduce("") { res, pid in
            if res == "" {
                return pid
            }
            return "\(res),\(pid)"
        }

        let categoryList = cart.map {
            $0.category
        }.reduce("") { res, pid in
            if res == "" {
                return pid
            }
            return "\(res),\(pid)"
        }

        let totalPrice = cart.map {
            $0.price * $0.quantity
        }.reduce(0) { total, num in
            total + num
        }

        Pam.track(event: "purchase_success", payload: ["product_id": productIDList, "product_cat": categoryList, "total_price": totalPrice])
    }
}
