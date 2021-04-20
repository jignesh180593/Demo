//
//  MessageViewController.swift
//  Left_Drawer
//
//  Created by Romal Tandel on 9/25/17.
//  Copyright © 2017 Romal Tandel. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {

    @IBOutlet weak var btnMenuButton: UIBarButtonItem!
     override func viewDidLoad() {
        super.viewDidLoad()
        btnMenuButton.target = revealViewController()
        btnMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
