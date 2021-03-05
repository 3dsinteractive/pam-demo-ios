//
//  ProductDescriptionCell.swift
//  pam-demo
//
//  Created by narongrit kanhanoi on 5/3/2564 BE.
//

import UIKit

class ProductDescriptionCell: UITableViewCell{
    
    @IBOutlet weak var descriptionText: UILabel!
    
    func setDescription(text: String) {
        descriptionText.text = text
    }
}
