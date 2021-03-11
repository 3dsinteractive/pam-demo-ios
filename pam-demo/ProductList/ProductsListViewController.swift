//
//  ProductsListViewController.swift
//  pam-demo
//
//  Created by narongrit kanhanoi on 4/3/2564 BE.
//

import UIKit

class ProductsListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var products: [ProductModel]?
   
    override func viewDidLoad() {
        
        overrideUserInterfaceStyle = .light
        navigationItem.title = "boodaBEST"
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
            layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            let size = CGSize(width:(collectionView!.bounds.width-30)/2, height: 250)
            layout.itemSize = size
        }
        
        if let layout = collectionView.collectionViewLayout as? PinterestLayout {
          layout.delegate = self
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setLoginBarItem()
        NotificationCenter.default.addObserver(self, selector: #selector(onReloadProduct), name: NSNotification.Name(rawValue: "favoriteChange"), object: nil)
        
        Pam.track(event: "page_view", payload: ["page_url":"boodabest://products", "page_title": "Product List"])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadProducts()
    }
    
    func initView() {
        tabBarItem.image = UIImage(named: "home_icon")
        tabBarItem?.title = "Home"
    }
    
    @objc func onReloadProduct(){
        loadProducts()
    }
    
    func setLoginBarItem() {
        let loginItem = UIImageView(image: UIImage(named: "profile1"))
        loginItem.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let loginButton = UIBarButtonItem(customView: loginItem)
        navigationItem.rightBarButtonItems = [loginButton]
    }
    
    func loadProducts() {
        products = MockAPI.main.getProducts()
        collectionView.reloadData()
    }
}

extension ProductsListViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "product_cell", for: indexPath)
        
        if let cell = cell as? ProductCell {
            let product = products?[indexPath.row]
            cell.setData(product: product)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let product = products?[indexPath.row] {
            if let vc = storyboard?.instantiateViewController(identifier: "ProductDetailViewController") as? ProductDetailViewController {
                vc.setProduct(product: product)
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    
}


extension ProductsListViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        return 300//photos[indexPath.item].image.size.height
    }
}
