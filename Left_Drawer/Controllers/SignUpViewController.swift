//
//  SignUpViewController.swift
//  Left_Drawer
//
//  Created by admin on 10/03/21.
//  Copyright © 2021 Romal Tandel. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var textFieldFirstName : UITextField!
    @IBOutlet weak var textFieldLastName : UITextField!
    @IBOutlet weak var textFieldEmail : UITextField!
    @IBOutlet weak var textFieldMobileNumber : UITextField!
    @IBOutlet weak var textFieldPassword : UITextField!
    @IBOutlet weak var textFieldConfirmPassword : UITextField!
    @IBOutlet weak var btnTermsCondition : UIButton!
    @IBOutlet weak var btnSignup : UIButton!
    @IBOutlet weak var btnAlreadyAccount : UIButton!
    @IBOutlet weak var bgTermsConditionView : UIView!
    @IBOutlet weak var bgTermsView : UIView!
    
    var textFields : [[UITextField : String]] = []
    var isChecked = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sign up"
        // Do any additional setup after loading the view.
        textFields = [[textFieldFirstName : "First name"], [textFieldLastName : "Last name"], [textFieldEmail : "E-mail"], [textFieldPassword : "Password"], [textFieldMobileNumber : "Mobile"],[textFieldConfirmPassword : "Confirm Password"]]
        
        // Text Fields placeholder colors are set in Interface Builder
        
        textFieldFirstName.delegate = self
        textFieldLastName.delegate = self
        textFieldEmail.delegate = self
        textFieldPassword.delegate = self
        textFieldMobileNumber.delegate = self
        textFieldConfirmPassword.delegate = self
        
        bgTermsConditionView.isHidden = true
        bgTermsView.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        if COMMON.isKeyPresentInUserDefaults(key: CONSTANT.IsEnglish){
            let IsEnglish = UserDefaults.standard.bool(forKey: CONSTANT.IsEnglish)
            IsEnglish ? btnSignup.setTitle(Localizable.ENSignup, for: .normal) : btnSignup.setTitle(Localizable.URSignup, for: .normal)
            IsEnglish ? btnTermsCondition.setTitle(Localizable.ENTERMS, for: .normal) : btnTermsCondition.setTitle(Localizable.URTERMS, for: .normal)
            IsEnglish ? btnAlreadyAccount.setTitle(Localizable.ENAlreadyAccount, for: .normal) : btnAlreadyAccount.setTitle(Localizable.URAlreadyAccount, for: .normal)

            if IsEnglish {
                title = Localizable.ENSignup
                textFieldFirstName.placeholder = Localizable.ENFirstname
                textFieldLastName.placeholder = Localizable.ENLastname
                textFieldEmail.placeholder = Localizable.ENEmail
                textFieldMobileNumber.placeholder = Localizable.ENMobilenumber
                textFieldPassword.placeholder = Localizable.ENPassword
                textFieldConfirmPassword.placeholder = Localizable.ENConfirmpassword
            }else {
                title = Localizable.URSignup
                textFieldFirstName.placeholder = Localizable.URFirstname
                textFieldLastName.placeholder = Localizable.URLastname
                textFieldEmail.placeholder = Localizable.UREmail
                textFieldMobileNumber.placeholder = Localizable.URMobilenumber
                textFieldPassword.placeholder = Localizable.URPassword
                textFieldConfirmPassword.placeholder = Localizable.URConfirmpassword
            }
        }else{
            UserDefaults.standard.setValue(true, forKey: CONSTANT.IsEnglish)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == textFieldPassword {
            let maxLength = 16
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        else if textField == textFieldMobileNumber {
            let length = textField.text?.count
            return length! < 10
        }else{
            return true
        }
    }
    
    @IBAction func tapBgTermsCondition(_ sender: UITapGestureRecognizer) {
        bgTermsConditionView.isHidden = true
        bgTermsView.isHidden = true
    }
    @IBAction func termsConditionnPress(_ sender: UIButton) {
        bgTermsConditionView.isHidden = false
        bgTermsView.isHidden = false
    }
    @IBAction func signupPress(_ sender: UIButton) {
        if isChecked {
            if !checkIfTextFieldsAreEmpty(textfields: textFields) {
                if textFieldPassword.text == textFieldConfirmPassword.text {
                    
                let emailId = (textFieldEmail.text?.replacingOccurrences(of: " ", with: ""))!
                if !(emailId.isEmail()) {
                    showAlert(title: nil, message: "Please enter valid email", actionTitle: "OK")
                    return
                }
                
                if (textFieldPassword.text?.count)! <= 6 {
                    showAlert(title: nil, message: "Please enter password more then 6 character", actionTitle: "OK")
                    return
                }
                
                 //ActivityIndication Start
                ActivityIndicator.activityIndicator("", parentView: self.view)
                var social = Social()
                social.first_name = textFieldFirstName.text!
                social.last_name = textFieldLastName.text!
                social.email = textFieldEmail.text!
                social.Mobile = textFieldMobileNumber.text!
                social.Password = textFieldPassword.text!
                    
                    HOSPITALAPI.registerNormalUser(social: social, successHandler: {_ in
                        self.navigationController?.popViewController(animated: true)
                        
                    }) { (ErrorMessage) in
                        self.showAlert(title: nil, message: ErrorMessage, actionTitle: "OK")
                        //ActivityIndication Stop
                        let delay = 2 // seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
                            ActivityIndicator.removeActivityIndicator()
                        }
                    }
                
                }else{
                    self.showAlert(title: nil, message: "Please enter correct password", actionTitle: "OK")
                }
            }
        }else{
            self.showAlert(title: "", message: "Please select term and condition ", actionTitle: "OK")
        }
    }
    @IBAction func alreadyAccountPress(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func okPress(_ sender: UIButton) {
        isChecked = true
        btnTermsCondition.setImage(UIImage(named: "checked.png"), for: .normal)
        bgTermsConditionView.isHidden = true
        bgTermsView.isHidden = true
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
