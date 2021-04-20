//
//  ChangePwdViewController.swift
//  Left_Drawer
//
//  Created by admin on 09/03/21.
//  Copyright © 2021 Romal Tandel. All rights reserved.
//

import UIKit

class ChangePwdViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var textfiledOldPwd : UITextField!
    @IBOutlet weak var textfiledPassword : UITextField!
    
    var textFields : [[UITextField : String]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Account"

        // Do any additional setup after loading the view.
        textFields = [[textfiledOldPwd : "Old Password"], [textfiledPassword : "New Password"]]
        
        textfiledOldPwd.delegate = self
        textfiledPassword.delegate = self
        navigationController!.isNavigationBarHidden = false
    }
    @IBAction func changePress(_ sender: UIButton) {
        if !checkIfTextFieldsAreEmpty(textfields: textFields) {
            guard let old_password = textfiledOldPwd.text , let new_password = textfiledPassword.text else {
                return
            }
            HOSPITALAPI.changePwdDoctor(old_password: old_password, new_password: new_password) { (message) in
                print(message)
                self.view.makeToast(message)
                self.navigationController?.popToRootViewController(animated: true)
            } failureHandler: { (message) in
                self.showAlert(title: nil, message:message , actionTitle: "OK")
            }
        }
    }
    @IBAction func clearPress(_ sender: UIButton) {
        textfiledOldPwd.text = ""
        textfiledPassword.text = ""
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
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
}
