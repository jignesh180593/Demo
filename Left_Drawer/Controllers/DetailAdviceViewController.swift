//
//  DetailAdviceViewController.swift
//  Left_Drawer
//
//  Created by admin on 16/03/21.
//  Copyright © 2021 Romal Tandel. All rights reserved.
//

import UIKit

class DetailAdviceViewController: UIViewController {
    @IBOutlet weak var img : UIImageView!
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblDesc : UILabel!
    @IBOutlet weak var btnYoutube : UIButton!
    @IBOutlet weak var btnCall : UIButton!
    
    var doctorAdvice : DoctorAdvice!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let image = doctorAdvice.image,let title = doctorAdvice.title,let desc = doctorAdvice.description,let youtube = doctorAdvice.youtube,let phone = doctorAdvice.phone else {
         return
        }
        if youtube == "" {
            btnYoutube.isHidden = true
        }
        if phone == "" {
            btnCall.isHidden = true
        }
        if image != "" {
            img.downloadImageFromUrl(image)
        }
        lblName.text = title
        lblDesc.text = desc
    }

    @IBAction func ytcallClicked(_ sender: UIButton) {
            guard let youtube = doctorAdvice.youtube,let phone = doctorAdvice.phone else {
                return
            }
            if sender.tag == 10 {
                if let url = URL(string: youtube) {
                    UIApplication.shared.open(url)
                }
            }
            if sender.tag == 11 {
                if let phoneCallURL = URL(string: "tel://\(phone)") {
                   let application:UIApplication = UIApplication.shared
                   if (application.canOpenURL(phoneCallURL)) {
                       application.open(phoneCallURL, options: [:], completionHandler: nil)
                   }
               }
            }
    }
}
