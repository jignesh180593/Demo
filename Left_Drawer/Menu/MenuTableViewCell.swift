//
//  MenuTableViewCell.swift
//  Left_Drawer
//
//  Created by Romal Tandel on 9/25/17.
//  Copyright © 2017 Romal Tandel. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblMenu: UILabel!
    @IBOutlet weak var bgView:UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
