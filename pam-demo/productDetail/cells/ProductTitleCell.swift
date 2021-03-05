//
//  ProductTitleCell.swift
//  pam-demo
//
//  Created by narongrit kanhanoi on 5/3/2564 BE.
//

import UIKit

class ProductTitleCell: UITableViewCell{
    
    @IBOutlet weak var titleText: UILabel!
    
    func setTitle(text: String) {
        titleText.text = text
    }
}
