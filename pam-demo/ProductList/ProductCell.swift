//
//  ProductCell.swift
//  pam-demo
//
//  Created by narongrit kanhanoi on 4/3/2564 BE.
//
import Nuke
import UIKit

class ProductCell: UICollectionViewCell {
    @IBOutlet var productTitle: UILabel!
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var productPrice: UILabel!

    @IBOutlet var favIcon: UIImageView!

    func setData(product: ProductModel?) {
        if let url = URL(string: product?.image ?? "") {
            let req = ImageRequest(url: url)
            Nuke.loadImage(with: req, into: productImage)
        }
        productTitle.text = product?.title
        if let priceText = product?.price {
            productPrice.text = "฿ \(priceText)"
        } else {
            productPrice.text = "-"
        }

        if product?.isFavorite == true {
            favIcon.isHidden = false
        } else {
            favIcon.isHidden = true
        }
    }
}
