//
//  AppointmentViewController.swift
//  Left_Drawer
//
//  Created by admin on 05/03/21.
//  Copyright © 2021 Romal Tandel. All rights reserved.
//

import UIKit
import DropDown

extension Date {
    static var yesterday: Date { return Date().dayBefore }
        static var tomorrow:  Date { return Date().dayAfter }
        var dayBefore: Date {
            return Calendar.current.date(byAdding: .day, value: 2, to: noon)!
        }
        var dayAfter: Date {
            return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
        }
        var noon: Date {
            return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
        }
    
 static func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, dd/MM/yyyy"
        return dateFormatter.string(from: Date())
    }
}
class AppointmentViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var btnOne : UIButton!
    @IBOutlet weak var btnTwo : UIButton!
    @IBOutlet weak var btnThree : UIButton!
    @IBOutlet weak var view1 : UIView!
    @IBOutlet weak var view2 : UIView!
    @IBOutlet weak var btnMale : KGRadioButton!
    @IBOutlet weak var btnFemale : KGRadioButton!
    @IBOutlet weak var btnBack : UIButton!
    @IBOutlet weak var btnNext : UIButton!
    @IBOutlet weak var btnBPYes : KGRadioButton!
    @IBOutlet weak var btnBPNo : KGRadioButton!
    @IBOutlet weak var btnDibetesYes : KGRadioButton!
    @IBOutlet weak var btnDibetesNo : KGRadioButton!
    @IBOutlet weak var viewform1 : UIView!
    @IBOutlet weak var viewform2 : UIView!
    @IBOutlet weak var viewform3 : UIView!
    @IBOutlet weak var textFieldName : UITextField!
    @IBOutlet weak var textFieldAge : UITextField!
    @IBOutlet weak var textFieldAddress : UITextField!
    @IBOutlet weak var textFieldDistrict : UITextField!
    @IBOutlet weak var textFieldSOWO : UITextField!
    @IBOutlet weak var textFieldMobile : UITextField!
    @IBOutlet weak var lblNameOfDay : UILabel!
    @IBOutlet weak var lblDateOfDay : UILabel!
    @IBOutlet weak var lblNameOfDay1 : UILabel!
    @IBOutlet weak var lblDateOfDay1 : UILabel!
    @IBOutlet weak var lblNameOfDay2 : UILabel!
    @IBOutlet weak var lblDateOfDay2 : UILabel!
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var viewDate1 : UIView!
    @IBOutlet weak var viewDate2 : UIView!
    @IBOutlet weak var viewDate3 : UIView!
    @IBOutlet weak var btnDoctor : UIButton!
    @IBOutlet weak var btnProcedure : UIButton!
    @IBOutlet weak var lblGender : UILabel!
    @IBOutlet weak var lblBP : UILabel!
    @IBOutlet weak var lblDiabetes : UILabel!
    @IBOutlet weak var lblSelectDoctor : UILabel!
    @IBOutlet weak var lblSelectProcedure : UILabel!
    @IBOutlet weak var lblMeetDoctor : UILabel!
    @IBOutlet weak var lblSelectTiming : UILabel!
    @IBOutlet weak var lblBPYes : UILabel!
    @IBOutlet weak var lblBPNo : UILabel!
    @IBOutlet weak var lblDiabetesYes : UILabel!
    @IBOutlet weak var lblDiabetesNo : UILabel!
    @IBOutlet weak var lblMale : UILabel!
    @IBOutlet weak var lblFemale : UILabel!

    var textFields : [[UITextField : String]] = []
    var textFieldsForm2 : [[UITextField : String]] = []

    var gender = "Male"
    var count = 1
    var BP = "No"
    var Diabetes = "No"
    var appointment = Appointment()
    var arrDoctor = [Doctor]()
    var arrProcedure = [Procedure]()
    var arrTimeSlot = [String]()
    var arrDate = [String]()
    var arrDoctorFees = [DoctorFees]()
    
    let dropDown = DropDown()
    var selectedIndex = Int ()

    override func viewDidLoad() {
        super.viewDidLoad()
        roundButton()
        btnBack.isHidden = true
        viewform2.isHidden = true
        viewform3.isHidden = true
        viewform1.isHidden = false
        
        textFields = [[textFieldName : "Name"], [textFieldAge : "age"], [textFieldAddress : "Address"], [textFieldDistrict : "District"]]
        textFieldsForm2 = [[textFieldSOWO : "S/O W/O"],[textFieldMobile : "Mobile"]]
        
        textFieldName.delegate = self
        textFieldAge.delegate = self
        textFieldAddress.delegate = self
        textFieldDistrict.delegate = self
        textFieldSOWO.delegate = self
        textFieldMobile.delegate = self
        
        // Do any additional setup after loading the view.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        let size = CGSize(width:84, height: 50)
        layout.itemSize = size
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        viewDate2.layer.borderWidth = 2
        viewDate2.layer.borderColor = UIColor.black.cgColor
        viewDate3.layer.borderWidth = 2
        viewDate3.layer.borderColor = UIColor.black.cgColor
        
        let date = Date()
        let calendar = Calendar.current
        let components1 = calendar.dateComponents([.weekday, .weekdayOrdinal, .day], from: date)
        let day1 = components1.day
        let components2 = calendar.dateComponents([.weekday, .weekdayOrdinal, .day], from: Date.tomorrow)
        let day2 = components2.day
        let components3 = calendar.dateComponents([.weekday, .weekdayOrdinal, .day], from: Date.yesterday)
        let day3 = components3.day
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        dateFormatter1.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let todayDt = dateFormatter1.string(from: Date())
        print("date: \(todayDt)")

        let tomorrowDt = dateFormatter1.string(from: Date.tomorrow)
        let nextDayDt = dateFormatter1.string(from: Date.yesterday)
        arrDate.append(todayDt)
        arrDate.append(tomorrowDt)
        arrDate.append(nextDayDt)
        UserDefaults.standard.setValue(todayDt, forKey: "appointment_date")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, yyyy-MM-dd"
        let today = dateFormatter.string(from: Date())
        let tomorrow = dateFormatter.string(from: Date.tomorrow)
        let nextDay = dateFormatter.string(from: Date.yesterday)
        
        let todayName = String(today.prefix(3))
        let tommorowName = String(tomorrow.prefix(3))
        let nextName = String(nextDay.prefix(3))
        
        lblNameOfDay.text = todayName
        lblNameOfDay1.text = tommorowName
        lblNameOfDay2.text = nextName
        
        lblDateOfDay.text = "\(day1 ?? 0)"
        lblDateOfDay1.text = "\(day2 ?? 0)"
        lblDateOfDay2.text = "\(day3 ?? 0)"
        
        getDoctorList()
    }
    override func viewDidAppear(_ animated: Bool) {
        guard let screen = UserDefaults.standard.string(forKey: "Screen") else {
            return
        }
        if screen == "MenuAppointment" {
            if #available(iOS 14.0, *) {
                let button1 = UIBarButtonItem(image: UIImage(named: "menu"))
                button1.target = revealViewController()
                button1.action = #selector(SWRevealViewController.revealToggle(_:))
                self.navigationItem.leftBarButtonItem  = button1
            } else {
                let button1 = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
                self.navigationItem.leftBarButtonItem  = button1
            }
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        UserDefaults.standard.removeObject(forKey: "Screen")
    }
    override func viewWillAppear(_ animated: Bool) {
        if COMMON.isKeyPresentInUserDefaults(key: CONSTANT.IsEnglish){
            let IsEnglish = UserDefaults.standard.bool(forKey: CONSTANT.IsEnglish)
           
            if IsEnglish {
                title = Localizable.ENLogin
                textFieldName.placeholder = Localizable.ENName
                textFieldAge.placeholder = Localizable.ENAge
                lblGender.text = Localizable.ENGender
                textFieldAddress.placeholder = Localizable.ENAddress
                textFieldDistrict.placeholder = Localizable.ENDistrict
                textFieldSOWO.placeholder = Localizable.ENSOWO
                textFieldMobile.placeholder = Localizable.ENMobile
                lblBP.text = Localizable.ENDOBP
                lblDiabetes.text = Localizable.ENDOdiabetes
                lblSelectDoctor.text = Localizable.ENSelectDoctor
                lblSelectProcedure.text = Localizable.ENSelectProcedure
                lblMeetDoctor.text = Localizable.ENMeetDoctor
                lblSelectTiming.text = Localizable.ENSelectTiming
                lblBPYes.text = Localizable.ENYes
                lblBPNo.text = Localizable.ENNo
                lblDiabetesYes.text = Localizable.ENYes
                lblDiabetesNo.text = Localizable.ENNo
                lblMale.text = Localizable.ENMale
                lblFemale.text = Localizable.ENFemale
            }else {
                title = Localizable.URLogin
                textFieldName.placeholder = Localizable.URName
                textFieldAge.placeholder = Localizable.URAge
                lblGender.text = Localizable.URGender
                textFieldAddress.placeholder = Localizable.URAddress
                textFieldDistrict.placeholder = Localizable.URDistrict
                textFieldSOWO.placeholder = Localizable.URSOWO
                textFieldMobile.placeholder = Localizable.URMobile
                lblBP.text = Localizable.URDOBP
                lblDiabetes.text = Localizable.URDOdiabetes
                lblSelectDoctor.text = Localizable.URSelectDoctor
                lblSelectProcedure.text = Localizable.URSelectProcedure
                lblMeetDoctor.text = Localizable.URMeetDoctor
                lblSelectTiming.text = Localizable.URSelectTiming
                lblBPYes.text = Localizable.URYes
                lblBPNo.text = Localizable.URNo
                lblDiabetesYes.text = Localizable.URYes
                lblDiabetesNo.text = Localizable.URNo
                lblMale.text = Localizable.URMale
                lblFemale.text = Localizable.URFemale
            }
        }else{
            UserDefaults.standard.setValue(true, forKey: CONSTANT.IsEnglish)
        }
    }
    func roundButton(){
        btnOne.layer.cornerRadius = btnOne.frame.width/2
        btnTwo.layer.cornerRadius = btnTwo.frame.width/2
        btnThree.layer.cornerRadius = btnThree.frame.width/2
    }
    func getDoctorList(){
        HOSPITALAPI.getDoctorList { [self] (Doctor) in
            arrDoctor = Doctor
            if arrDoctor.count > 0 {
                btnDoctor.setTitle(arrDoctor[0].docter_name, for: .normal)
                UserDefaults.standard.setValue(arrDoctor[0].id, forKey: CONSTANT.Doctor_id)
            }
           
            getProcedureList()
         } failureHandler: { (Error) in
            print(Error)
        }
    }
    func getProcedureList(){
        HOSPITALAPI.getProcedureList { [self] (Procedure) in
            arrProcedure = Procedure
            btnProcedure.setTitle(arrProcedure[0].procedure_name, for: .normal)
            if arrDoctor.count > 0 {
                getTimeslotList()
            }
         } failureHandler: { (Error) in
            print(Error)
        }
    }
    func getTimeslotList(){
        HOSPITALAPI.getTimeSlotList { [self] (TimeSlot) in
            arrTimeSlot = TimeSlot.slots!
            collectionView.reloadData()
         } failureHandler: { (Error) in
            print(Error)
        }
    }
    func getDoctorCharge(){
        ActivityIndicator.activityIndicator("", parentView: self.view)

        HOSPITALAPI.getDoctorFeesList { [self] (DoctorFees) in
            arrDoctorFees = DoctorFees
            UserDefaults.standard.setValue(arrDoctorFees[0].charge, forKey: CONSTANT.DoctorFees)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                ActivityIndicator.removeActivityIndicator()
            }
            sentToPayment()
         } failureHandler: { (Error) in
            print(Error)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                ActivityIndicator.removeActivityIndicator()
            }
        }
    }
    func sentPatientInfo(){
        HOSPITALAPI.sentPatientData(appointment: appointment, successHandler: { (message) in
           // self.showAlert(title: nil, message:message , actionTitle: "OK")
//            self.textFieldName.text = ""
//            self.textFieldAge.text = ""
//            self.textFieldAddress.text = ""
//            self.textFieldDistrict.text = ""
//            self.textFieldSOWO.text = ""
//            self.textFieldMobile.text = ""
        }) { (message) in
            self.showAlert(title: nil, message:message , actionTitle: "OK")
        }
    }
    func sentAppointmentInfo(){
        ActivityIndicator.activityIndicator("", parentView: self.view)
        HOSPITALAPI.sentAppointInfoData(appointment: appointment, successHandler: { (message) in
           // self.showAlert(title: nil, message:message , actionTitle: "OK")
           print(message)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                ActivityIndicator.removeActivityIndicator()
            }
            self.getDoctorCharge()
        }) { (message) in
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                ActivityIndicator.removeActivityIndicator()
            }
            self.showAlert(title: nil, message:message , actionTitle: "OK")
        }
    }
    func sentToPayment(){
        let mainStoryBoard:UIStoryboard = UIStoryboard(name : "Main" ,bundle : nil)
        let desController = mainStoryBoard.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
        desController.appointment = appointment
        self.navigationController?.pushViewController(desController, animated: true)
    }
    @IBAction func didPressButton(_ sender: KGRadioButton) {
        if sender.tag == 10 {
            btnMale.isSelected = true
            btnFemale.isSelected = false
            gender = "Male"
        }
        if sender.tag == 11 {
            btnFemale.isSelected = true
            btnMale.isSelected = false
            gender = "Female"
        }
        if sender.tag == 15 {
            btnBPYes.isSelected = true
            btnBPNo.isSelected = false
            BP = "Yes"
        }
        if sender.tag == 16 {
            btnBPNo.isSelected = true
            btnBPYes.isSelected = false
            BP = "No"
        }
        if sender.tag == 17 {
            btnDibetesYes.isSelected = true
            btnDibetesNo.isSelected = false
            Diabetes = "Yes"
        }
        if sender.tag == 18 {
            btnDibetesNo.isSelected = true
            btnDibetesYes.isSelected = false
            Diabetes = "No"
        }
    }
    @IBAction func didPressBackButton(_ sender: UIButton) {
        if count == 2 {
            viewform2.isHidden = true
            viewform1.isHidden = false
            btnBack.isHidden = true
            view1.backgroundColor = .white
            btnTwo.backgroundColor = .white
            btnTwo.setTitleColor(.black, for: .normal)
        }
        if count == 3 {
            viewform3.isHidden = true
            viewform1.isHidden = true
            viewform2.isHidden = false
            view2.backgroundColor = .white
            btnThree.backgroundColor = .white
            btnThree.setTitleColor(.black, for: .normal)
        }
        count = count - 1
    }
    @IBAction func didPressNextButton(_ sender: UIButton) {
        if count == 1 && !checkIfTextFieldsAreEmpty(textfields: textFields) {
            appointment.Name = textFieldName.text!
            appointment.Age = textFieldAge.text!
            appointment.Address = textFieldAddress.text!
            appointment.District = textFieldDistrict.text!
            appointment.Gender = gender
            ShowElementsform2()
            count = count + 1
        }
        else if count == 2 && !checkIfTextFieldsAreEmpty(textfields: textFieldsForm2) {
            appointment.SOWO = textFieldSOWO.text!
            appointment.Mobile = textFieldMobile.text!
            appointment.BP = BP
            appointment.Diabetes = Diabetes
            ShowElementsform3()
            sentPatientInfo()
            count = count + 1
        }
        else if count == 3 {
            let appointment_date = UserDefaults.standard.string(forKey: "appointment_date")
            let patient_id = UserDefaults.standard.string(forKey: CONSTANT.patient_id)
            let docter_id = UserDefaults.standard.string(forKey: CONSTANT.Doctor_id)
            let slot_time = UserDefaults.standard.string(forKey: CONSTANT.slot_time)
            appointment.appointment_date = appointment_date
            appointment.patient_id = patient_id!
            appointment.docter_id = docter_id!
            appointment.procedure_id = "0"
            appointment.slot_time = slot_time!
            sentAppointmentInfo()
        }
    }
    @IBAction func didPressSelectDoctorButton(_ sender: UIButton) {
        var arrName = [String]()
        for dt in arrDoctor {
            arrName.append(dt.docter_name!)
        }
        dropDown.dataSource = arrName
        dropDown.anchorView = sender //5
           dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
           dropDown.show() //7
           dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
            guard let id = self!.arrDoctor[index].id else {
                return
            }
            print(id)
            UserDefaults.standard.setValue(id, forKey: CONSTANT.Doctor_id)
             guard let _ = self else { return }
             sender.setTitle(item, for: .normal) //9
            self!.getTimeslotList()
           }
    }
    @IBAction func didPressSelectProcedureButton(_ sender: UIButton) {
        var arrName = [String]()
        for dt in arrProcedure {
            arrName.append(dt.procedure_name!)
        }
        dropDown.dataSource = arrName
        dropDown.anchorView = sender //5
           dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
           dropDown.show() //7
           dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
             guard let _ = self else { return }
             sender.setTitle(item, for: .normal) //9
           }
    }
    
    @IBAction func tapDate1(_ sender: UITapGestureRecognizer) {
        viewDate2.layer.borderWidth = 2
        viewDate2.layer.borderColor = UIColor.black.cgColor
        viewDate2.backgroundColor = .white
        
        viewDate3.layer.borderWidth = 2
        viewDate3.layer.borderColor = UIColor.black.cgColor
        viewDate3.backgroundColor = .white
        
        viewDate1.backgroundColor = UIColor(red: 40 / 255.0, green: 116 / 255.0, blue: 98 / 255.0, alpha: 1.0)
        lblNameOfDay.textColor = .white
        lblDateOfDay.textColor = .white
        
        lblNameOfDay1.textColor = UIColor(red: 40 / 255.0, green: 116 / 255.0, blue: 98 / 255.0, alpha: 1.0)
        lblDateOfDay1.textColor = UIColor(red: 40 / 255.0, green: 116 / 255.0, blue: 98 / 255.0, alpha: 1.0)
        lblNameOfDay2.textColor = UIColor(red: 40 / 255.0, green: 116 / 255.0, blue: 98 / 255.0, alpha: 1.0)
        lblDateOfDay2.textColor = UIColor(red: 40 / 255.0, green: 116 / 255.0, blue: 98 / 255.0, alpha: 1.0)
        UserDefaults.standard.setValue(arrDate[0], forKey: "appointment_date")
    }
    @IBAction func tapDate2(_ sender: UITapGestureRecognizer) {
        viewDate1.layer.borderWidth = 2
        viewDate1.layer.borderColor = UIColor.black.cgColor
        viewDate1.backgroundColor = .white
        
        viewDate3.layer.borderWidth = 2
        viewDate3.layer.borderColor = UIColor.black.cgColor
        viewDate3.backgroundColor = .white
        
        viewDate2.backgroundColor = UIColor(red: 40 / 255.0, green: 116 / 255.0, blue: 98 / 255.0, alpha: 1.0)
        lblNameOfDay1.textColor = .white
        lblDateOfDay1.textColor = .white
        
        lblNameOfDay.textColor = UIColor(red: 40 / 255.0, green: 116 / 255.0, blue: 98 / 255.0, alpha: 1.0)
        lblDateOfDay.textColor = UIColor(red: 40 / 255.0, green: 116 / 255.0, blue: 98 / 255.0, alpha: 1.0)
        lblNameOfDay2.textColor = UIColor(red: 40 / 255.0, green: 116 / 255.0, blue: 98 / 255.0, alpha: 1.0)
        lblDateOfDay2.textColor = UIColor(red: 40 / 255.0, green: 116 / 255.0, blue: 98 / 255.0, alpha: 1.0)
        UserDefaults.standard.setValue(arrDate[1], forKey: "appointment_date")
    }
    @IBAction func tapDate3(_ sender: UITapGestureRecognizer) {
        viewDate2.layer.borderWidth = 2
        viewDate2.layer.borderColor = UIColor.black.cgColor
        viewDate2.backgroundColor = .white
        
        viewDate3.layer.borderWidth = 2
        viewDate3.layer.borderColor = UIColor.black.cgColor
        viewDate3.backgroundColor = .white
        
        viewDate3.backgroundColor = UIColor(red: 40 / 255.0, green: 116 / 255.0, blue: 98 / 255.0, alpha: 1.0)
        lblNameOfDay2.textColor = .white
        lblDateOfDay2.textColor = .white
        
        lblNameOfDay.textColor = UIColor(red: 40 / 255.0, green: 116 / 255.0, blue: 98 / 255.0, alpha: 1.0)
        lblDateOfDay.textColor = UIColor(red: 40 / 255.0, green: 116 / 255.0, blue: 98 / 255.0, alpha: 1.0)
        lblNameOfDay1.textColor = UIColor(red: 40 / 255.0, green: 116 / 255.0, blue: 98 / 255.0, alpha: 1.0)
        lblDateOfDay1.textColor = UIColor(red: 40 / 255.0, green: 116 / 255.0, blue: 98 / 255.0, alpha: 1.0)
        UserDefaults.standard.setValue(arrDate[2], forKey: "appointment_date")
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == textFieldMobile && string != ""{
            let length = textField.text?.count
            return length! < 10
        }
        if textField == textFieldAge && string != ""{
            let length = textField.text?.count
            return length! < 2
        }
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        textField.resignFirstResponder()
        return false
    }
    func showAlert(title: String?, message: String, actionTitle:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func checkIfTextFieldsAreEmpty(textfields: [[UITextField : String]]) -> Bool{
        var isEmpty = false
        var endExecution = false
        for dictionary in textfields {
            if endExecution {
                break
            }
            for (textfield, name) in dictionary {
                guard (textfield.text?.isEmpty)! else {
                    isEmpty = false
                    continue
                }
                showAlert(title: nil, message: "\(name) is mandatory!", actionTitle: "OK")
                isEmpty = true
                endExecution = true
            }
        }
        return isEmpty
    }
    func ShowElementsform2(){
        viewform2.isHidden = false
        viewform1.isHidden = true
        btnBack.isHidden = false
        view1.backgroundColor = UIColor(red: 40 / 255.0, green: 116 / 255.0, blue: 98 / 255.0, alpha: 1.0)
        btnTwo.backgroundColor = UIColor(red: 40 / 255.0, green: 116 / 255.0, blue: 98 / 255.0, alpha: 1.0)
        btnTwo.setTitleColor(.white, for: .normal)
    }
    func ShowElementsform3(){
        viewform3.isHidden = false
        viewform2.isHidden = true
        viewform1.isHidden = true
        view2.backgroundColor = UIColor(red: 40 / 255.0, green: 116 / 255.0, blue: 98 / 255.0, alpha: 1.0)
        btnThree.backgroundColor = UIColor(red: 40 / 255.0, green: 116 / 255.0, blue: 98 / 255.0, alpha: 1.0)
        btnThree.setTitleColor(.white, for: .normal)
    }
}
extension AppointmentViewController : UICollectionViewDelegate,UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTimeSlot.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimingViewCell", for: indexPath) as! TimingViewCell
        if indexPath.row == selectedIndex {
            cell.viewBG.backgroundColor = UIColor(red: 40 / 255.0, green: 116 / 255.0, blue: 98 / 255.0, alpha: 1.0)
            cell.lbltime.textColor = .white
            UserDefaults.standard.setValue(arrTimeSlot[indexPath.row], forKey: CONSTANT.slot_time)
        }else{
            cell.viewBG.backgroundColor = .white
            cell.viewBG.layer.borderWidth = 2
            cell.viewBG.layer.borderColor = UIColor.black.cgColor
            cell.lbltime.textColor = UIColor(red: 40 / 255.0, green: 116 / 255.0, blue: 98 / 255.0, alpha: 1.0)
        }
        cell.lbltime.text = arrTimeSlot[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UserDefaults.standard.setValue(arrTimeSlot[indexPath.row], forKey: CONSTANT.slot_time)
        selectedIndex = indexPath.row
        collectionView.reloadData()
    }
}
