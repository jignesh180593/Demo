//
//  MobileViewController.swift
//  Left_Drawer
//
//  Created by admin on 09/03/21.
//  Copyright © 2021 Romal Tandel. All rights reserved.
//

import UIKit

class MobileViewController: UIViewController ,UITextFieldDelegate{
    @IBOutlet weak var textFieldMobileNumber : UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textFieldMobileNumber.delegate = self
    }
    @IBAction func generateOtpPress(_ sender: UIButton) {
        guard let mobileNumber = textFieldMobileNumber.text else {
            return
        }
        HOSPITALAPI.verifyMobile(mobileNumber: mobileNumber) { (message) in
            print(message)
            let mainStoryBoard:UIStoryboard = UIStoryboard(name : "Main" ,bundle : nil)
            let desController = mainStoryBoard.instantiateViewController(withIdentifier: "VerifyOTPViewController") as! VerifyOTPViewController
            desController.mobileNumber = mobileNumber
            self.navigationController?.pushViewController(desController, animated: true)
        } failureHandler: { (message) in
            self.showAlert(title: nil, message:message , actionTitle: "OK")
        }
    }
    func showAlert(title: String?, message: String, actionTitle:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == textFieldMobileNumber {
            let length = textField.text?.count
            return length! < 10
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
