//
//  NormalViewController.swift
//  Left_Drawer
//
//  Created by admin on 03/03/21.
//  Copyright © 2021 Romal Tandel. All rights reserved.
//

import UIKit

class NormalViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate {
    @IBOutlet weak var textFieldName : UITextField!
    @IBOutlet weak var textFieldEmail : UITextField!
    @IBOutlet weak var textFieldcontactNumber : UITextField!
    @IBOutlet weak var textViewIssue : UITextView!
    @IBOutlet weak var textViewDescription : UITextView!
    
    var textFields : [[UITextField : String]] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Is this normal ?"
        placeHoderColor(textField: textFieldName,string: "Name")
        placeHoderColor(textField: textFieldEmail, string: "Email")
        placeHoderColor(textField: textFieldcontactNumber, string: "Contact Number")
        
        textFields = [[textFieldName : "Name"], [textFieldEmail : "E-mail"], [textFieldcontactNumber : "Contact-Number"]]
        
        textFieldName.delegate = self
        textFieldEmail.delegate = self
        textFieldcontactNumber.delegate = self
        
        textViewIssue.delegate = self
        textViewDescription.delegate = self
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
  
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView == textViewIssue && textView.text == "" {
            textViewIssue.text = "Issue you are facing"
        }
        if textView == textViewDescription && textView.text == "" {
            textViewDescription.text = "Description"
        }
        return true
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView == textViewIssue && textView.text == "Issue you are facing" {
            textView.text = ""
        }
        if textView == textViewDescription && textView.text == "Description" {
            textView.text = ""
        }
        return true
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
           if(text == "\n") {
               textView.resignFirstResponder()
               return false
           }
           return true
    }
    @IBAction func PressedSubmit(_ sender: UIButton) {
        if !checkIfTextFieldsAreEmpty(textfields: textFields) {
            if textViewIssue.text != "" {
                var normal = Normal()
                normal.Name = textFieldName.text!
                normal.email = textFieldEmail.text!
                normal.phone = textFieldcontactNumber.text!
                normal.issue = textViewIssue.text
                normal.description = textViewDescription.text
                sentNormalData(normal: normal)
            }else{
                showAlert(title: nil, message: "Message is mandatory!", actionTitle: "OK")
            }
        }
    }
    func sentNormalData(normal:Normal){
        HOSPITALAPI.sentIsNormalData(normal: normal, successHandler: { (message) in
            self.showAlert(title: nil, message:message , actionTitle: "OK")
            self.textFieldName.text = ""
            self.textFieldEmail.text = ""
            self.textFieldcontactNumber.text = ""
        }) { (message) in
            self.showAlert(title: nil, message:message , actionTitle: "OK")
        }
    }
    func placeHoderColor(textField:UITextField,string:String){
        textField.attributedPlaceholder = NSAttributedString(string: string,attributes: [NSAttributedString.Key.foregroundColor: UIColor.green])
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
    func showAlert(title: String?, message: String, actionTitle:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
}
