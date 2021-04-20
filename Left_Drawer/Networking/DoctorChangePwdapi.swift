//
//  DoctorChangePwdapi.swift
//  Left_Drawer
//
//  Created by admin on 09/03/21.
//  Copyright © 2021 Romal Tandel. All rights reserved.
//

import Foundation
import Alamofire

extension HOSPITALAPI {
    static func changePwdDoctor(old_password:String,new_password:String,successHandler: @escaping (_ message:String)->(), failureHandler: @escaping (_ errorMessage:String)->()) {
       let url = URL(string: baseUrl + "/Docters/pls_change_password")!
        guard let doctor_id = UserDefaults.standard.string(forKey: CONSTANT.Doctor_id) else{
            return
        }
        Alamofire.request(url, method: .post, parameters: ["doctor_id":doctor_id,"old_password":old_password,"new_password":new_password], encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseJSON(completionHandler: { data in
          if data.result.isSuccess {
               print(NSString(data: data.data!, encoding: String.Encoding.utf8.rawValue) ?? "Kobaja")
           do {
               let jsonData = try data.data!
               let successResult: SuccessResult = try! JSONDecoder().decode(SuccessResult.self, from: jsonData)
               if successResult.result == "300"{
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
