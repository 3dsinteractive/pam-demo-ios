//
//  ShoppingCartViewController.swift
//  pam-demo
//
//  Created by narongrit kanhanoi on 4/3/2564 BE.
//

import UIKit
import Nuke

class ShoppingCartViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPriceText: UILabel!
    
    var cart:[ProductModel] = []
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadCart()
    }
    
    func loadCart() {
        cart = MockAPI.main.getCart()
        
        let total = cart.map{
            $0.price * $0.quantity
        }.reduce(0){ total, num in
            total + num
        }
        
        totalPriceText.text = "฿ \(total)"
        
        tableView.reloadData()
    }
    
    
    
    func initView() {
        tabBarItem.title = "Cart"
        tabBarItem.image = UIImage(named: "cart_icon")
    }
}

extension ShoppingCartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath)
        
        if let cell = cell as? CartItemCell{
            let product = cart[indexPath.row]
            cell.setProduct(product: product)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
}

class CartItemCell: UITableViewCell{
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var unitPrice: UILabel!
    @IBOutlet weak var quantityText: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    
    func setProduct(product:ProductModel) {
        if let url = URL(string: product.image){
            Nuke.loadImage(with: url, into: productImage)
        }
        productTitle.text = product.title
        unitPrice.text = "฿ \(product.price)"
        quantityText.text = "x \(product.quantity)"
        
        let total = product.price * product.quantity
        totalPrice.text = "฿ \(total)"
    }
    
}
