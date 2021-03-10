//
//  ShoppingCartViewController.swift
//  pam-demo
//
//  Created by narongrit kanhanoi on 4/3/2564 BE.
//

import Nuke
import UIKit

class ShoppingCartViewController: UIViewController {
    @IBOutlet var emptyCartText: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var totalPriceText: UILabel!

    var cart: [ProductModel] = []
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self

        NotificationCenter.default.addObserver(self, selector: #selector(cartChange), name: NSNotification.Name(rawValue: "cartChange"), object: nil)
    }

    @objc func cartChange() {
        loadCart()
    }

    override func viewDidAppear(_: Bool) {
        loadCart()
    }

    func loadCart() {
        cart = MockAPI.main.getCart()

        let total = cart.map {
            $0.price * $0.quantity
        }.reduce(0) { total, num in
            total + num
        }

        totalPriceText.text = "฿ \(total)"

        tableView.reloadData()

        if cart.count < 1 {
            emptyCartText.isHidden = false
        } else {
            emptyCartText.isHidden = true
        }
    }

    @IBAction func clickPayNow(_: Any) {
        if let vc = storyboard?.instantiateViewController(identifier: "PaymentViewColtroller") as? PaymentViewColtroller {
            present(vc, animated: true)
        }
    }

    func initView() {
        tabBarItem.title = "Cart"
        tabBarItem.image = UIImage(named: "cart_icon")
    }
}

extension ShoppingCartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return cart.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath)

        if let cell = cell as? CartItemCell {
            let product = cart[indexPath.row]
            cell.setProduct(product: product)
        }

        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 170
    }
}

class CartItemCell: UITableViewCell {
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var productTitle: UILabel!
    @IBOutlet var unitPrice: UILabel!
    @IBOutlet var quantityText: UILabel!
    @IBOutlet var totalPrice: UILabel!

    func setProduct(product: ProductModel) {
        if let url = URL(string: product.image) {
            Nuke.loadImage(with: url, into: productImage)
        }
        productTitle.text = product.title
        unitPrice.text = "฿ \(product.price)"
        quantityText.text = "x \(product.quantity)"

        let total = product.price * product.quantity
        totalPrice.text = "฿ \(total)"
    }
}
