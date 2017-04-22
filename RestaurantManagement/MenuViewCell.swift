//
//  MenuViewCell.swift
//  RestaurantManagement
//
//  Created by Bill on 4/22/17.
//  Copyright © 2017 Bill. All rights reserved.
//

import UIKit

class MenuViewCell: UITableViewCell {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var foodImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
