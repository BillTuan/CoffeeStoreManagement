//
//  ChooseFoodTableViewCell.swift
//  RestaurantManagement
//
//  Created by Bill on 4/17/17.
//  Copyright © 2017 Bill. All rights reserved.
//

import UIKit

class ChooseFoodTableViewCell: UITableViewCell {

    @IBOutlet weak var foodID: UILabel!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var nameFoodLabel: UILabel!
    @IBOutlet weak var priceFoodLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
