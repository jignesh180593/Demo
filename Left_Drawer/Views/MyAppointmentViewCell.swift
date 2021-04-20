//
//  MyAppointmentViewCell.swift
//  Left_Drawer
//
//  Created by admin on 10/03/21.
//  Copyright © 2021 Romal Tandel. All rights reserved.
//

import UIKit

class MyAppointmentViewCell: UITableViewCell {
    @IBOutlet weak var lblPetientName : UILabel!
    @IBOutlet weak var lblDoctorname : UILabel!
    @IBOutlet weak var lblProcedureType : UILabel!
    @IBOutlet weak var lblAppointmenttime : UILabel!
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
