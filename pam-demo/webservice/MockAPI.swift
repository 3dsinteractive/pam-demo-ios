//
//  MockAPI.swift
//  pam-demo
//
//  Created by narongrit kanhanoi on 4/3/2564 BE.
//

import Foundation

class MockAPI {
    static let main = MockAPI()

    var cart: [ProductModel] = []

    func login(email: String) -> UserModel? {
        let user = userTable.filter {
            $0["email"] == email
        }
        if user.count == 1 {
            let u = user[0]
            let user = UserModel(name: u["name"] ?? "",
                                 custID: u["cust_id"] ?? "",
                                 email: u["email"] ?? "",
                                 profileImage: u["profile_image"] ?? "")
            return user
        }
        return nil
    }

    func getProducts() -> [ProductModel] {
        return products
    }

    func getFavoriteProducts() -> [ProductModel] {
        let favProducts = products.filter {
            $0.isFavorite
        }
        return favProducts
    }

    func setFavorite(isFav: Bool, productID: String) {
        let count = products.count - 1
        for i in 0 ... count {
            if productID == products[i].productID {
                products[i].isFavorite = isFav
            }
        }
    }

    func getCart() -> [ProductModel] {
        return cart
    }

    func getCartCount() -> Int {
        let count = cart.map {
            $0.quantity
        }.reduce(0) { total, num in
            total + num
        }
        return count
    }

    func addToCart(product: ProductModel) {
        var foundAt = -1
        if cart.count > 0 {
            let count = cart.count - 1
            for i in 0 ... count {
                if cart[i].productID == product.productID {
                    foundAt = i
                    break
                }
            }
        }
        if foundAt == -1 {
            let p = ProductModel(image: product.image, title: product.title, price: product.price, description: product.description, productID: product.productID, isFavorite: product.isFavorite, quantity: 1, category: product.category)
            cart.append(p)
        } else {
            cart[foundAt].quantity += 1
        }
    }

    func pay() {
        cart = []
    }
}
