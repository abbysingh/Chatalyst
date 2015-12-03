//
//  RightCell.swift
//  Chatalyst
//
//  Created by Robin Malhotra on 03/12/15.
//  Copyright © 2015 Abheyraj. All rights reserved.
//

import UIKit

class RightCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
