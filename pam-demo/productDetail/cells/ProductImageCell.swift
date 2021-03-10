//
//  ProductImageCell.swift
//  pam-demo
//
//  Created by narongrit kanhanoi on 5/3/2564 BE.
//

import Nuke
import UIKit
class ProductImageCell: UITableViewCell {
    @IBOutlet var productImage: UIImageView!

    func loadImage(url: String) {
        if let url = URL(string: url) {
            Nuke.loadImage(with: url, into: productImage)
        }
    }
}
