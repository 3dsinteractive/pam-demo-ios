//
//  ProductFavoriteCell.swift
//  pam-demo
//
//  Created by narongrit kanhanoi on 5/3/2564 BE.
//

import UIKit

class ProductFavoriteCell: UITableViewCell{
    
    @IBOutlet weak var favImage: UIImageView!
    
    var fav = false
    var productID = ""
    func setFavorite(fav:Bool, productID: String) {
        self.fav = fav
        self.productID = productID
        setFavIcon()
        
        let ges = UITapGestureRecognizer(target: self, action: #selector(setFav))
        favImage.isUserInteractionEnabled = true
        favImage.addGestureRecognizer(ges)
    }
    
    @objc func setFav(){
        fav = !fav
        MockAPI.main.setFavorite(isFav: fav, productID: productID)
        setFavIcon()
        
        Pam.track(event: "favorite", payload: ["product_id": productID])
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "favoriteChange"), object: nil)
    }
    
    func setFavIcon() {
        if fav {
            favImage.image = UIImage(named: "fav_active")
        }else{
            favImage.image = UIImage(named: "fav")
        }
    }
    
}
