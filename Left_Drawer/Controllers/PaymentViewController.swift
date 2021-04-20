//
//  PaymentViewController.swift
//  Left_Drawer
//
//  Created by admin on 08/03/21.
//  Copyright © 2021 Romal Tandel. All rights reserved.
//

import UIKit
import Razorpay

class PaymentViewController: UIViewController,RazorpayPaymentCompletionProtocol {

    let razorpayKey = "rzp_test_a0rJISyGKFw9fN"//"rzp_test_a0rJISyGKFw9fN"
    var razorpay: RazorpayCheckout!//Razorpay!
    var appointment = Appointment()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        openRazorpayCheckout()
    }
    private func openRazorpayCheckout() {
        // 1. Initialize razorpay object with provided key. Also depending on your requirement you can assign delegate to self. It can be one of the protocol from RazorpayPaymentCompletionProtocolWithData, RazorpayPaymentCompletionProtocol.
        razorpay = RazorpayCheckout.initWithKey(razorpayKey, andDelegate: self)
        let amount = UserDefaults.standard.string(forKey: CONSTANT.DoctorFees)!
        guard let name = appointment.Name , let mobile = appointment.Mobile else {
            return
        }
        let options: [String:Any] = [
            "amount": "\(amount)", //This is in currency subunits. 100 = 100 paise= INR 1.
            "currency": "INR",//We support more that 92 international currencies.
            "description": "purchase description",
            "image": "https://url-to-image.png",
            "name": "\(name)",
            "prefill": [
                "contact": "\(mobile)",
                "email": "rathodjignesh1805@gmail.com"
            ],
            "theme": [
                "color": "#ADD8E6"
            ]
        ]
        if let rzp = self.razorpay {
            rzp.open(options, displayController: self)
        } else {
            print("Unable to initialize")
        }
    }
    
    func onPaymentSuccess(_ payment_id: String) {
//        checkout.txnID = payment_id
//        checkout.user_id = UserDefaults.standard.string(forKey: CONSTANT.userID)!
//        checkOut()
        print("payment_id:=="+payment_id)
        //remove all 
        Dashboard()
    }
    
    func onPaymentError(_ code: Int32, description str: String) {
        print("error:=="+str)
    }
    func Dashboard(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        self.navigationController?.pushViewController(nextViewController, animated: true)
            
    }
}
