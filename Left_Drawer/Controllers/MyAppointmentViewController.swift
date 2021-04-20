//
//  MyAppointmentViewController.swift
//  Left_Drawer
//
//  Created by admin on 10/03/21.
//  Copyright © 2021 Romal Tandel. All rights reserved.
//

import UIKit
import DropDown

class MyAppointmentViewController: UIViewController {
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var menuButton:UIBarButtonItem!

    var arrMyAppointmentData = [MyAppointment]()
    let dropDown = DropDown()
    var arrMore = [String]()
    var ISEnglish = true
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pulse Hospital"
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
         }
        getMyAppointmentList()
    }
    override func viewWillAppear(_ animated: Bool) {
        if COMMON.isKeyPresentInUserDefaults(key: CONSTANT.IsEnglish){
            let IsEnglish = UserDefaults.standard.bool(forKey: CONSTANT.IsEnglish)
            if IsEnglish {
                ISEnglish = true
                title = Localizable.ENPulseHospital
                arrMore = [Localizable.ENMap,Localizable.ENCall]
            }else {
                ISEnglish = false
                title = Localizable.URPulseHospital
                arrMore = [Localizable.URMap,Localizable.URCall]
            }
        }else{
            UserDefaults.standard.setValue(true, forKey: CONSTANT.IsEnglish)
        }
        if #available(iOS 14.0, *) {
            let button1 = UIBarButtonItem(image: UIImage(named: "more"))
            button1.target = self
            button1.action = #selector(tapMoreOption)
            self.navigationItem.rightBarButtonItem  = button1
        } else {
            let button1 = UIBarButtonItem(image: UIImage(named: "more"), style: .plain, target: self, action: #selector(tapMoreOption))
            self.navigationItem.rightBarButtonItem  = button1
        }
    }
    @objc func tapMoreOption(){
        dropDown.dataSource = arrMore
        dropDown.anchorView = self.navigationItem.rightBarButtonItem //5
           dropDown.bottomOffset = CGPoint(x: 0, y: 50) //6
           dropDown.show() //7
           dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
           
             guard let _ = self else { return }
            if (self!.ISEnglish && item == Localizable.ENMap) || (!self!.ISEnglish && item == Localizable.URMap){
                let customURL = "https://maps.app.goo.gl/isrdH7t5CiuXpGBi8"

                if UIApplication.shared.canOpenURL(URL(string: customURL)!) {
                    UIApplication.shared.openURL(URL(string: customURL)!)
                }
            }else{
                if let phoneCallURL = URL(string: "tel://01912462462") {
                   let application:UIApplication = UIApplication.shared
                   if (application.canOpenURL(phoneCallURL)) {
                       application.open(phoneCallURL, options: [:], completionHandler: nil)
                   }
               }
            }
           }
    }
    func getMyAppointmentList(){
        HOSPITALAPI.getMyAppointmentListData { (MyAppointment) in
            self.arrMyAppointmentData.removeAll()
            self.arrMyAppointmentData = MyAppointment
            self.tableView.reloadData()
        } failureHandler: { (Error) in
            print(Error)
        }
    }
}
extension MyAppointmentViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMyAppointmentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyAppointmentViewCell", for: indexPath) as! MyAppointmentViewCell
        cell.lblPetientName.text = arrMyAppointmentData[indexPath.row].patient_name
        cell.lblDoctorname.text = arrMyAppointmentData[indexPath.row].doctor
        cell.lblProcedureType.text = arrMyAppointmentData[indexPath.row].procedure
        cell.lblAppointmenttime.text = "Appointment time : " + arrMyAppointmentData[indexPath.row].allocated_time!
        cell.lblDate.text = "Date : " + arrMyAppointmentData[indexPath.row].date!
        return cell
    }
}
