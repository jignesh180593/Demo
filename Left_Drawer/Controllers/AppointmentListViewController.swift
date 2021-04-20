//
//  AppointmentListViewController.swift
//  Left_Drawer
//
//  Created by admin on 09/03/21.
//  Copyright © 2021 Romal Tandel. All rights reserved.
//

import UIKit

class AppointmentListViewController: UIViewController {
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var bgView : UIView!
    @IBOutlet weak var popView : UIView!
    @IBOutlet weak var formDt : DateButton!
    @IBOutlet weak var toDt : DateButton!
    
    var arrDoctorAppointmentData = [AppointmentListDoctor]()
    var datePickerView : UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Appointment list"
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        bgView.isHidden = true
        popView.isHidden = true
        datePickerView = UIDatePicker()
        getAppointmentList()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        if #available(iOS 14.0, *) {
            let button1 = UIBarButtonItem(image: UIImage(named: "sort"))
            button1.target = self
            button1.action = #selector(filterData)
            self.navigationItem.rightBarButtonItem  = button1
        } else {
            let button1 = UIBarButtonItem(image: UIImage(named: "sort"), style: .plain, target: self, action: #selector(filterData))
            self.navigationItem.rightBarButtonItem  = button1
        }
    }
    @objc func filterData(){
        print("filterData")
        bgView.isHidden = false
        popView.isHidden = false
    }
    func getAppointmentList(){
        HOSPITALAPI.getDoctorAppointmentListData { [self] (DoctorAppointmentData) in
            self.arrDoctorAppointmentData.removeAll()
            arrDoctorAppointmentData = DoctorAppointmentData
            tableView.reloadData()
         } failureHandler: { (Error) in
            print(Error)
        }
    }
    func getFilterAppointmentList(){
        guard let start_date = formDt.titleLabel?.text , let end_date = toDt.titleLabel?.text else {
            return
        }
        HOSPITALAPI.getFilterDoctorAppointmentListData(start_date: start_date, end_date: end_date) { (DoctorAppointmentData) in
            self.arrDoctorAppointmentData.removeAll()
            self.arrDoctorAppointmentData = DoctorAppointmentData
            self.tableView.reloadData()
        } failureHandler: { (Error) in
            print(Error)
        }
    }
    @IBAction func fromDtPress(_ sender: DateButton) {
         datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }
    @IBAction func toDtPress(_ sender: DateButton) {
         datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker1(sender:)), for: .valueChanged)
    }
    @IBAction func okPress(_ sender: UIButton) {
        datePickerView.removeFromSuperview()
        bgView.isHidden = true
        popView.isHidden = true
        if formDt.titleLabel?.text?.lowercased() != "from date" || toDt.titleLabel?.text?.lowercased() != "to date" {
            getFilterAppointmentList()
        }
    }
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        formDt.setTitle(dateFormatter.string(from: sender.date), for: .normal)
    }
    @objc func handleDatePicker1(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        toDt.setTitle(dateFormatter.string(from: sender.date), for: .normal)
    }
}
extension AppointmentListViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDoctorAppointmentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentViewCell", for: indexPath) as! AppointmentViewCell
        cell.lblPetientName.text = arrDoctorAppointmentData[indexPath.row].patient_name
        cell.lblAppointmenttype.text = arrDoctorAppointmentData[indexPath.row].appointment_type
        cell.lblProcedureType.text = arrDoctorAppointmentData[indexPath.row].procedure
        cell.lblMobile.text = arrDoctorAppointmentData[indexPath.row].mobile
        cell.lblDate.text = "Date : " + arrDoctorAppointmentData[indexPath.row].date!
        return cell
    }
}
