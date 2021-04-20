//
//  DoctorLoginViewController.swift
//  Left_Drawer
//
//  Created by admin on 09/03/21.
//  Copyright © 2021 Romal Tandel. All rights reserved.
//

import UIKit

class DoctorLoginViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var textfiledID : UITextField!
    @IBOutlet weak var textfiledPassword : UITextField!
    @IBOutlet weak var btnDoctorLogin : UIButton!

    var textFields : [[UITextField : String]] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textFields = [[textfiledID : "User name"], [textfiledPassword : "Password"]]
        
        textfiledID.delegate = self
        textfiledPassword.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        if COMMON.isKeyPresentInUserDefaults(key: CONSTANT.IsEnglish){
            let IsEnglish = UserDefaults.standard.bool(forKey: CONSTANT.IsEnglish)
            IsEnglish ? btnDoctorLogin.setTitle(Localizable.ENDoctorLogin, for: .normal) : btnDoctorLogin.setTitle(Localizable.URDoctorLogin, for: .normal)

            if IsEnglish {
                title = Localizable.ENLogin
                textfiledID.placeholder = Localizable.ENUsername
                textfiledPassword.placeholder = Localizable.ENPassword
            }else {
                title = Localizable.URLogin
                textfiledID.placeholder = Localizable.URUsername
                textfiledPassword.placeholder = Localizable.URPassword
            }
        }else{
            UserDefaults.standard.setValue(true, forKey: CONSTANT.IsEnglish)
        }
    }
    func Dashboard(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DoctorDashboardViewController") as! DoctorDashboardViewController
        
        //animation
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        //end
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
        guard let navigationController = self.navigationController else { return }
        var navigationArray = navigationController.viewControllers // To get all UIViewController stack as Array
        if navigationArray.count > 1{
            navigationArray.remove(at: navigationArray.count - 2) // To remove second last UIViewController
        }else{
            navigationArray.remove(at: navigationArray.count - 1) // To remove second last UIViewController
        }
        navigationController.isNavigationBarHidden = true
        self.navigationController?.viewControllers = navigationArray
     }
    @IBAction func loginPress(_ sender: UIButton) {
        if !checkIfTextFieldsAreEmpty(textfields: textFields) {
            var login = Login()
            login.UserName = textfiledID.text!
            login.Password = textfiledPassword.text!
            sentLoginData(login: login)
        }
    }
    func sentLoginData(login:Login){
        HOSPITALAPI.senDoctortLoginData(login: login, successHandler: { (message) in
            self.textfiledID.text = ""
            self.textfiledPassword.text = ""
            self.Dashboard()
        }) { (message) in
            self.showAlert(title: nil, message:message , actionTitle: "OK")
        }
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
