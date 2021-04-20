//
//  ContactUsViewController.swift
//  Left_Drawer
//
//  Created by admin on 05/03/21.
//  Copyright © 2021 Romal Tandel. All rights reserved.
//

import UIKit
import DropDown

class ContactUsViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var contactNoTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var menuButton:UIBarButtonItem!

    var textFields : [[UITextField : String]] = []
    let dropDown = DropDown()
    var arrMore = [String]()
    var ISEnglish = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Pulse Hospital"
        textFields = [[fullNameTextField : "Full name"], [emailAddressTextField : "E-mail"], [contactNoTextField : "Contact-no"], [messageTextField : "Message"]]
        
        emailAddressTextField.delegate = self
        fullNameTextField.delegate = self
        contactNoTextField.delegate = self
        messageTextField.delegate = self
        
        // Do any additional setup after loading the view.
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
         }
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
    @IBAction func submitClicked(_ sender: UIButton) {
        if !checkIfTextFieldsAreEmpty(textfields: textFields) {
            var contact = Contact()
            contact.Name = fullNameTextField.text!
            contact.email = emailAddressTextField.text!
            contact.phone = contactNoTextField.text!
            contact.message = messageTextField.text
            sentContactData(contact: contact)
        }
    }
    @IBAction func callClicked(_ sender: UIButton) {
            if let phoneCallURL = URL(string: "tel://+9107860000097") {
               let application:UIApplication = UIApplication.shared
               if (application.canOpenURL(phoneCallURL)) {
                   application.open(phoneCallURL, options: [:], completionHandler: nil)
               }
           }
       }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == contactNoTextField {
            let length = textField.text?.count
            return length! < 10
        }
        return true
    }
    func sentContactData(contact:Contact){
        HOSPITALAPI.sentContactData(contact: contact, successHandler: { (message) in
            self.showAlert(title: nil, message:message , actionTitle: "OK")
            self.fullNameTextField.text = ""
            self.emailAddressTextField.text = ""
            self.contactNoTextField.text = ""
            self.messageTextField.text = ""
        }) { (message) in
            self.showAlert(title: nil, message:message , actionTitle: "OK")
        }
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
}
