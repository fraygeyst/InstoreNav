//
//  TableViewCell.swift
//  TTTTTTTABBBBBBBBBBBBB
//
//  Created by Zintel, Marc on 12.12.19.
//  Copyright © 2019 Zintel, Marc. All rights reserved.
//
// Inititalisiierung der Zellen

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var imageProd: UIImageView!
    @IBOutlet weak var nameProd: UILabel!
    @IBOutlet weak var brandProd: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var oldPriceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
