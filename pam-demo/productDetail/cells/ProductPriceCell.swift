//
//  ProductPriceCell.swift
//  pam-demo
//
//  Created by narongrit kanhanoi on 5/3/2564 BE.
//

import UIKit
class ProductPriceCell: UITableViewCell {
    
    @IBOutlet weak var priceText: UILabel!
    
    func setPrice(price: Int) {
        priceText.text = "฿ \(price)"
    }
    
}
