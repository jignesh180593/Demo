//
//  ContactApi.swift
//  Left_Drawer
//
//  Created by admin on 05/03/21.
//

import Foundation
import Alamofire

extension HOSPITALAPI {
     static func sentContactData(contact:Contact,successHandler: @escaping (_ message:String)->(), failureHandler: @escaping (_ errorMessage:String)->()) {
            let url = URL(string: baseUrl + "/Contact/send_contact")!
        Alamofire.request(url, method: .post, parameters: ["name":contact.Name,"email":contact.email,"mobile":contact.phone,"message":contact.message], encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseJSON(completionHandler: { data in
               if data.result.isSuccess {
                    print(NSString(data: data.data!, encoding: String.Encoding.utf8.rawValue) ?? "Kobaja")
                do {
                    let jsonData = try data.data!
                    let successResult: SuccessResult = try! JSONDecoder().decode(SuccessResult.self, from: jsonData)
                    if successResult.result == "300"{
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
