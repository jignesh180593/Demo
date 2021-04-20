//
//  AppointmentViewCell.swift
//  Left_Drawer
//
//  Created by admin on 09/03/21.
//  Copyright © 2021 Romal Tandel. All rights reserved.
//

import UIKit

class AppointmentViewCell: UITableViewCell {
    @IBOutlet weak var lblPetientName : UILabel!
    @IBOutlet weak var lblAppointmenttype : UILabel!
    @IBOutlet weak var lblProcedureType : UILabel!
    @IBOutlet weak var lblMobile : UILabel!
    @IBOutlet weak var lblDate : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
