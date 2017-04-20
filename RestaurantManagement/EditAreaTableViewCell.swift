//
//  EditAreaTableViewCell.swift
//  RestaurantManagement
//
//  Created by Bill on 4/19/17.
//  Copyright © 2017 Bill. All rights reserved.
//

import UIKit

class EditAreaTableViewCell: UITableViewCell {

    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
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
