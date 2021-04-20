//
//  AboutusViewController.swift
//  Left_Drawer
//
//  Created by admin on 10/03/21.
//  Copyright © 2021 Romal Tandel. All rights reserved.
//

import UIKit

class AboutusViewController: UIViewController {
    @IBOutlet weak var viewBorder : UIView!
    @IBOutlet weak var menuButton:UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "About us"
        viewBorder.layer.borderWidth = 0.5
        viewBorder.layer.borderColor = UIColor.lightGray.cgColor
        
        // Do any additional setup after loading the view.
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
         }
    }
}
