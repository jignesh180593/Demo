//
//  LoginApi.swift
//  Left_Drawer
//
//  Created by admin on 08/03/21.
//  Copyright © 2021 Romal Tandel. All rights reserved.
//

import Foundation
import Alamofire

extension HOSPITALAPI {
     static func sentLoginData(login:Login,successHandler: @escaping (_ message:String)->(), failureHandler: @escaping (_ errorMessage:String)->()) {
            let url = URL(string: baseUrl + "/Users/pls_login")!
        Alamofire.request(url, method: .post, parameters: ["user_id":login.UserName,"password":login.Password], encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseJSON(completionHandler: { data in
               if data.result.isSuccess {
                    print(NSString(data: data.data!, encoding: String.Encoding.utf8.rawValue) ?? "Kobaja")
                do {
                    let jsonData = try data.data!
                    let loginResult: LoginResult = try! JSONDecoder().decode(LoginResult.self, from: jsonData)
                    if loginResult.result == "300"{
                        successHandler(loginResult.message!)
                        UserDefaults.standard.setValue(true, forKey: CONSTANT.IsLogin)
                        UserDefaults.standard.setValue(loginResult.user_id, forKey: CONSTANT.User_id)
                        UserDefaults.standard.setValue(loginResult.user_email, forKey: CONSTANT.User_Email)
                        UserDefaults.standard.setValue(loginResult.user_mobile, forKey: CONSTANT.User_Mobile)
                    }else  if loginResult.result == "200"{
                        failureHandler(loginResult.message!)
                    }
                } catch {
                    print("Error: Couldn't parse JSON. \(error.localizedDescription)")
                }
                }else{
                   failureHandler("Something went to wrong")
               }
           })
       }
    static func senDoctortLoginData(login:Login,successHandler: @escaping (_ message:String)->(), failureHandler: @escaping (_ errorMessage:String)->()) {
           let url = URL(string: baseUrl + "/Docters/pls_login")!
       Alamofire.request(url, method: .post, parameters: ["user_id":login.UserName,"password":login.Password], encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseJSON(completionHandler: { data in
              if data.result.isSuccess {
                   print(NSString(data: data.data!, encoding: String.Encoding.utf8.rawValue) ?? "Kobaja")
               do {
                   let jsonData = try data.data!
                   let loginResult: DoctorResult = try! JSONDecoder().decode(DoctorResult.self, from: jsonData)
                   if loginResult.result == "300"{
                       successHandler("success")
                       UserDefaults.standard.setValue(true, forKey: CONSTANT.IsDoctorLogin)
                       UserDefaults.standard.setValue(loginResult.user_id, forKey: CONSTANT.User_id)
                       UserDefaults.standard.setValue(loginResult.doctor_id, forKey: CONSTANT.Doctor_id)
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
