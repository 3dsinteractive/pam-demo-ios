//
//  ProductCell.swift
//  pam-demo
//
//  Created by narongrit kanhanoi on 4/3/2564 BE.
//
import Nuke
import UIKit

class ProductCell: UICollectionViewCell{
    
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productPrice: UILabel!
    
    func setData(product: ProductModel?)  {
        if let url = URL(string: product?.image ?? ""){
            let req = ImageRequest(url: url)
            Nuke.loadImage(with: req, into: productImage)
        }
        productTitle.text = product?.title
        if let priceText = product?.price {
            productPrice.text = "฿ \(priceText)"
        }else{
            productPrice.text = "-"
        }
    }
}
