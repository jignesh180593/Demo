//
//  DoctorAdviceListViewCell.swift
//  Left_Drawer
//
//  Created by admin on 03/03/21.
//  Copyright © 2021 Romal Tandel. All rights reserved.
//

import UIKit

class DoctorAdviceListViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblDesc : UITextView!
    @IBOutlet weak var btnYoutube : UIButton!
    @IBOutlet weak var btnCall : UIButton!
    
    func setData(data:DoctorAdvice){
           guard let image = data.image,let title = data.title,let desc = data.description,let youtube = data.youtube,let phone = data.phone else {
            return
           }
            lblName.text = title
            lblDesc.text = desc
            if youtube == "" {
                btnYoutube.isHidden = true
            }
            if phone == "" {
                btnCall.isHidden = true
            }
            imageView.downloadImageFromUrl(image)
        }
}
