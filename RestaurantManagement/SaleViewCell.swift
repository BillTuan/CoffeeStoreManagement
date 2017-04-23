//
//  SaleViewCell.swift
//  RestaurantManagement
//
//  Created by Bill on 4/23/17.
//  Copyright © 2017 Bill. All rights reserved.
//

import UIKit

class SaleViewCell: UITableViewCell {

    @IBOutlet weak var foodMoney: UILabel!
    @IBOutlet weak var foodQuantity: UILabel!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
