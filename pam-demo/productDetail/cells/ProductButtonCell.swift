//
//  ProductButtonCell.swift
//  pam-demo
//
//  Created by narongrit kanhanoi on 5/3/2564 BE.
//

import UIKit

class ProductButtonCell: UITableViewCell {
    var onAddToCart: (() -> Void)?

    @IBAction func clickAddToCart(_: Any) {
        onAddToCart?()
    }

    var productID = ""
    func setProductID(productID: String) {
        self.productID = productID
    }
}
