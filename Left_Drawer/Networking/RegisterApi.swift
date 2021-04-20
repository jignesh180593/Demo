//
//  RegisterApi.swift
//  Left_Drawer
//
//  Created by admin on 09/03/21.
//

import Foundation
import Alamofire

extension HOSPITALAPI {
     static func registerUser(social:Social,successHandler: @escaping (_ message:String)->(), failureHandler: @escaping (_ errorMessage:String)->()) {
            let url = URL(string: baseUrl + "/Users/pulse_register")!
        Alamofire.request(url, method: .post, parameters: ["device_type":"iOS","lastname":social.last_name,"first_name":social.first_name,"email":social.email,"socialid":social.user_id,"pro_img":social.pro_img], encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseJSON(completionHandler: { data in
               if data.result.isSuccess {
                    print(NSString(data: data.data!, encoding: String.Encoding.utf8.rawValue) ?? "Kobaja")
                do {
                    let jsonData = try data.data!
                    let successResult: RegResult = try! JSONDecoder().decode(RegResult.self, from: jsonData)
                    if successResult.result == "300" || successResult.result == "200"{
                        UserDefaults.standard.setValue(true, forKey: CONSTANT.IsLogin)
                        UserDefaults.standard.setValue(successResult.user_id, forKey: CONSTANT.User_id)
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
    static func registerNormalUser(social:Social,successHandler: @escaping (_ message:String)->(), failureHandler: @escaping (_ errorMessage:String)->()) {
           let url = URL(string: baseUrl + "/Users/pulse_register")!
       Alamofire.request(url, method: .post, parameters: ["device_type":"iOS","lastname":social.last_name,"first_name":social.first_name,"email":social.email,"mobileno":social.Mobile,"password":social.Password], encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseJSON(completionHandler: { data in
              if data.result.isSuccess {
                   print(NSString(data: data.data!, encoding: String.Encoding.utf8.rawValue) ?? "Kobaja")
               do {
                   let jsonData = try data.data!
                   let successResult: RegResult = try! JSONDecoder().decode(RegResult.self, from: jsonData)
                   if successResult.result == "300" || successResult.result == "200"{
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
