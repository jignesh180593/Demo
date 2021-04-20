//
//  DoctorDashboardViewController.swift
//  Left_Drawer
//
//  Created by admin on 09/03/21.
//  Copyright © 2021 Romal Tandel. All rights reserved.
//

import UIKit

class DoctorDashboardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Navigation bar is hidden
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    @IBAction func changepwdPress(_ sender: UIButton) {
        let mainStoryBoard:UIStoryboard = UIStoryboard(name : "Main" ,bundle : nil)
        let desController = mainStoryBoard.instantiateViewController(withIdentifier: "ChangePwdViewController") as! ChangePwdViewController
        self.navigationController?.pushViewController(desController, animated: true)
    }
    @IBAction func appointmentPress(_ sender: UIButton) {
        let mainStoryBoard:UIStoryboard = UIStoryboard(name : "Main" ,bundle : nil)
        let desController = mainStoryBoard.instantiateViewController(withIdentifier: "AppointmentListViewController") as! AppointmentListViewController
        self.navigationController?.pushViewController(desController, animated: true)
    }
    @IBAction func logoutPress(_ sender: UIButton) {
        let alert = UIAlertController(title: "Pulse Hospital", message: "Do you really want to Logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
              switch action.style{
              case .default:
                    print("default")
                UserDefaults.standard.removeObject(forKey: CONSTANT.IsDoctorLogin)
                let mainStoryBoard:UIStoryboard = UIStoryboard(name : "Main" ,bundle : nil)
                let desController = mainStoryBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.navigationController?.pushViewController(desController, animated: true)
              case .cancel:
                    print("cancel")

              case .destructive:
                    print("destructive")

              @unknown default:
                print("default")
        }}))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
              switch action.style{
              case .default:
                    print("default")

              case .cancel:
                    print("cancel")
                alert.dismiss(animated: true, completion: nil)

              case .destructive:
                    print("destructive")

              @unknown default:
                print("default")
              }}))
        self.present(alert, animated: true, completion: nil)
        
    }
}
