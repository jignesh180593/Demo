//
//  VerifyOTPViewController.swift
//  Left_Drawer
//
//  Created by admin on 09/03/21.
//  Copyright © 2021 Romal Tandel. All rights reserved.
//

import UIKit

class VerifyOTPViewController: UIViewController ,UITextFieldDelegate{
    @IBOutlet weak var textFieldOTP : UITextField!
    var mobileNumber = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textFieldOTP.delegate = self

    }
    @IBAction func verifyOTPPress(_ sender: UIButton) {
        guard let otpNumber = textFieldOTP.text else {
            return
        }
        HOSPITALAPI.verifyOTP(mobileNumber: mobileNumber, otpNumber: otpNumber) { (message) in
            print(message)
            self.Dashboard()
        } failureHandler: { (message) in
            self.showAlert(title: nil, message:message , actionTitle: "OK")
        }
    }
    func showAlert(title: String?, message: String, actionTitle:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func Dashboard(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
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
        navigationArray.remove(at: navigationArray.count - 2) // To remove second last UIViewController
         self.navigationController?.viewControllers = navigationArray
     }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
