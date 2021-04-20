//
//  MobileApi.swift
//  Left_Drawer
//
//  Created by admin on 09/03/21.
//

import Foundation
import Alamofire

extension HOSPITALAPI {
     static func verifyMobile(mobileNumber:String,successHandler: @escaping (_ message:String)->(), failureHandler: @escaping (_ errorMessage:String)->()) {
            let url = URL(string: baseUrl + "/Users/checkmobileno")!
        Alamofire.request(url, method: .post, parameters: ["mobileno":mobileNumber], encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseJSON(completionHandler: { data in
               if data.result.isSuccess {
                    print(NSString(data: data.data!, encoding: String.Encoding.utf8.rawValue) ?? "Kobaja")
                do {
                    let jsonData = try data.data!
                    let successResult: SuccessResult = try! JSONDecoder().decode(SuccessResult.self, from: jsonData)
                    if successResult.result == "100"{
                        UserDefaults.standard.setValue(true, forKey: CONSTANT.IsLogin)
                        successHandler(successResult.message!)
                    }
                    if successResult.result == "200"{
                        failureHandler(successResult.message!)
                    }
                } catch {
                    print("Error: Couldn't parse JSON. \(error.localizedDescription)")
                }
                }else{
                   failureHandler("Something went to wrong")
               }
           })
       }
    static func verifyOTP(mobileNumber:String,otpNumber:String,successHandler: @escaping (_ message:String)->(), failureHandler: @escaping (_ errorMessage:String)->()) {
           let url = URL(string: baseUrl + "/Users/verifyotp")!
        Alamofire.request(url, method: .post, parameters: ["mobileno":mobileNumber,"otp":otpNumber], encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseJSON(completionHandler: { data in
              if data.result.isSuccess {
                   print(NSString(data: data.data!, encoding: String.Encoding.utf8.rawValue) ?? "Kobaja")
               do {
                   let jsonData = try data.data!
                   let successResult: SuccessResult = try! JSONDecoder().decode(SuccessResult.self, from: jsonData)
                   if successResult.result == "100"{
                       UserDefaults.standard.setValue(true, forKey: CONSTANT.IsLogin)
                       successHandler(successResult.message!)
                   }
               } catch {
                   print("Error: Couldn't parse JSON. \(error.localizedDescription)")
               }
               }else{
                  failureHandler("Something went to wrong")
              }
          })
      }
}
