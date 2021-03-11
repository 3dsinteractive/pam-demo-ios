//
//  ProductDetailViewController.swift
//  pam-demo
//
//  Created by narongrit kanhanoi on 5/3/2564 BE.
//

import UIKit

class ProductDetailViewController: UIViewController {
    @IBOutlet var tableView: UITableView!

    enum ProductCellType {
        case imageCell(String)
        case favoriteCell(Bool, String)
        case title(String)
        case description(String)
        case price(Int)
        case button(String)
    }

    var product: ProductModel?
    var cells: [ProductCellType] = []

    override func viewDidLoad() {
        overrideUserInterfaceStyle = .light
        tableView.delegate = self
        tableView.dataSource = self

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
    }

    override func viewDidAppear(_ animated: Bool) {
        
        let payload = [
            "page_url": "boodabest://product?id=\(product?.productID ?? "")",
            "page_title": "Product: \(product?.title ?? "")",
            "product_id": product?.productID ?? ""
        ]
        
        Pam.track(event: "page_view", payload: payload)
    }
    func setProduct(product: ProductModel) {
        self.product = product

        Pam.track(event: "page_view", payload: ["product_id": product.productID])

        if AppData.main.loginUser != nil {
            cells = [
                .imageCell(product.image),
                .favoriteCell(product.isFavorite, product.productID),
                .title(product.title),
                .price(product.price),
                .description(product.description),
                .button(product.productID),
            ]
        } else {
            cells = [
                .imageCell(product.image),
                .title(product.title),
                .price(product.price),
                .description(product.description),
            ]
        }
    }
}

extension ProductDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func getCellIdentifier(cell: ProductCellType) -> String {
        switch cell {
        case .imageCell:
            return "ProductImageCell"
        case .favoriteCell:
            return "ProductFavoriteCell"
        case .title:
            return "ProductTitleCell"
        case .description:
            return "ProductDescriptionCell"
        case .price:
            return "ProductPriceCell"
        case .button:
            return "ProductButtonCell"
        }
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return cells.count
    }

    func addToCart(product: ProductModel) {
        let alert = UIAlertController(title: "Add to cart", message: "Add this profuct to cart?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
            MockAPI.main.addToCart(product: product)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cartChange"), object: nil)
            self.navigationController?.popViewController(animated: true)

            Pam.track(event: "add_to_cart", payload: ["product_id": product.productID])
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in

        }))

        present(alert, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = cells[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: getCellIdentifier(cell: cellType)) ?? UITableViewCell()

        switch cellType {
        case let .imageCell(url):
            if let cell = cell as? ProductImageCell {
                cell.loadImage(url: url)
            }
        case let .favoriteCell(isFav, productID):
            if let cell = cell as? ProductFavoriteCell {
                cell.setFavorite(fav: isFav, productID: productID)
            }
        case let .title(title):
            if let cell = cell as? ProductTitleCell {
                cell.setTitle(text: title)
            }
        case let .description(desc):
            if let cell = cell as? ProductDescriptionCell {
                cell.setDescription(text: desc)
            }
        case let .price(price):
            if let cell = cell as? ProductPriceCell {
                cell.setPrice(price: price)
            }
        case let .button(productID):
            if let cell = cell as? ProductButtonCell {
                cell.setProductID(productID: productID)
                cell.onAddToCart = {
                    if let pd = self.product {
                        self.addToCart(product: pd)
                    }
                }
            }
        }

        return cell
    }
}
