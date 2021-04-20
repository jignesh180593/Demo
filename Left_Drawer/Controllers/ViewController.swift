//
//  ViewController.swift
//  Left_Drawer
//
//  Created by Romal Tandel on 9/25/17.
//  Copyright © 2017 Romal Tandel. All rights reserved.
//

import UIKit
import ImageSlideshow
import AlamofireImage
import DropDown

class ViewController: UIViewController {

    @IBOutlet weak var btnMenuButton: UIBarButtonItem!
    @IBOutlet weak var btnAppointment: UIButton!
    @IBOutlet weak var slideShow: ImageSlideshow!
    @IBOutlet weak var lblDoctorAdvice: UILabel!
    @IBOutlet weak var lblOrderMedicine: UILabel!
    @IBOutlet weak var lblSecondOpinion: UILabel!
    @IBOutlet weak var lblNormal: UILabel!
    
    var arrImage:[AlamofireSource] = []
    let dropDown = DropDown()
    var arrMore = [String]()
    var ISEnglish = true
    override func viewDidLoad() {
        super.viewDidLoad()
        slideShow.slideshowInterval = 5.0
        slideShow.activityIndicator = DefaultActivityIndicator()
        slideShow.contentScaleMode = UIViewContentMode.scaleToFill
        getSliderData()
        // Do any additional setup after loading the view, typically from a nib.
        btnMenuButton.target = revealViewController()
        btnMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
    }
    override func viewWillAppear(_ animated: Bool) {
        if COMMON.isKeyPresentInUserDefaults(key: CONSTANT.IsEnglish){
            let IsEnglish = UserDefaults.standard.bool(forKey: CONSTANT.IsEnglish)
            IsEnglish ? btnAppointment.setTitle(Localizable.ENAppointment, for: .normal) : btnAppointment.setTitle(Localizable.URAppointment, for: .normal)
            if IsEnglish {
                ISEnglish = true
                lblDoctorAdvice.text = Localizable.ENDoctorAdvice
                lblOrderMedicine.text = Localizable.ENOrderMedicine
                lblSecondOpinion.text = Localizable.ENSecondOpinion
                lblNormal.text = Localizable.ENNormal
                title = Localizable.ENPulseHospital
                arrMore = [Localizable.ENMap,Localizable.ENCall]
            }else {
                ISEnglish = false
                lblDoctorAdvice.text = Localizable.URDoctorAdvice
                lblOrderMedicine.text = Localizable.UROrderMedicine
                lblSecondOpinion.text = Localizable.URSecondOpinion
                lblNormal.text = Localizable.URNormal
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    func getSliderData(){
        HOSPITALAPI.getDashboarSliderData { (DashboardSlider) in
             for data in  DashboardSlider {
                guard let image = data.image else {
                    return
                }
                print(image)
                self.arrImage.append(AlamofireSource(urlString:image)!)
                self.slideShow.setImageInputs(self.arrImage)
            }
        } failureHandler: { (Error) in
            print(Error)
        }

    }
    func showAlert(title: String?, message: String, actionTitle:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func openWhatsUp(number:String){
        let message = ""
        let phone = number
        let urlWhats = "whatsapp://send?phone=\(phone)&text=\(message)"
        if phone != "" {
            if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
                if let whatsappURL = URL(string: urlString) {
                    if UIApplication.shared.canOpenURL(whatsappURL) {
                        UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                    } else {
                        //showAlert(title: "", message: "Install Whatsapp", actionTitle: "OK")
                        self.view.makeToast("You can connect the pulse hospital please install the whatsapp app.")
                    }
                }
            }
        }else{
            showAlert(title: "", message: "No number available", actionTitle: "OK")
        }
    }
    
    @IBAction func PressedDoctorAdvice(_ sender: UITapGestureRecognizer) {
        print("PressedDoctorAdvice")
        let mainStoryBoard:UIStoryboard = UIStoryboard(name : "Main" ,bundle : nil)
        let desController = mainStoryBoard.instantiateViewController(withIdentifier: "DoctorAdviceListViewController") as! DoctorAdviceListViewController
        self.navigationController?.pushViewController(desController, animated: true)
    }
    @IBAction func PressedOrderMedicine(_ sender: UITapGestureRecognizer) {
        print("PressedOrderMedicine")
       //openWhatsUp(number: "+919541941680")
        let mainStoryBoard:UIStoryboard = UIStoryboard(name : "Main" ,bundle : nil)
        let desController = mainStoryBoard.instantiateViewController(withIdentifier: "NormalViewController") as! NormalViewController
        self.navigationController?.pushViewController(desController, animated: true)
    }
    @IBAction func PressedSecondOpinion(_ sender: UITapGestureRecognizer) {
        print("PressedSecondOpinion")
        //openWhatsUp(number: "+919541941680")
    }
    @IBAction func PressedNormal(_ sender: UITapGestureRecognizer) {
        print("PressedNormal")
        let mainStoryBoard:UIStoryboard = UIStoryboard(name : "Main" ,bundle : nil)
        let desController = mainStoryBoard.instantiateViewController(withIdentifier: "NormalViewController") as! NormalViewController
        self.navigationController?.pushViewController(desController, animated: true)
    }
    @IBAction func PressedAppointment(_ sender: UIButton) {
        print("PressedAppointment")
        if  COMMON.isKeyPresentInUserDefaults(key: CONSTANT.IsLogin){
            let mainStoryBoard:UIStoryboard = UIStoryboard(name : "Main" ,bundle : nil)
            let desController = mainStoryBoard.instantiateViewController(withIdentifier: "AppointmentViewController") as! AppointmentViewController
            self.navigationController?.pushViewController(desController, animated: true)
        }else{
            let mainStoryBoard:UIStoryboard = UIStoryboard(name : "Main" ,bundle : nil)
            let desController = mainStoryBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(desController, animated: true)
        }
    }
}

