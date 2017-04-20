//
//  TableDetailTableViewCell.swift
//  RestaurantManagement
//
//  Created by Bill on 4/16/17.
//  Copyright © 2017 Bill. All rights reserved.
//

import UIKit

class TableDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var priceFoodLabel: UILabel!
    @IBOutlet weak var nameFoodLabel: UILabel!
    @IBOutlet weak var amountFoodLabel: UILabel!
    @IBOutlet weak var FoodImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
