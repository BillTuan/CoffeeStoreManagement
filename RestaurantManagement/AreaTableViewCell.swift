//
//  AreaTableViewCell.swift
//  RestaurantManagement
//
//  Created by Bill on 4/16/17.
//  Copyright © 2017 Bill. All rights reserved.
//

import UIKit

class AreaTableViewCell: UITableViewCell {

    @IBOutlet weak var detailFloorLabel: UILabel!
    @IBOutlet weak var floorLabel: UILabel!
    @IBOutlet weak var areaImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
