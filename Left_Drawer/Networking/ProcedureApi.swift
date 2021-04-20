//
//  ProcedureApi.swift
//  Left_Drawer
//
//  Created by admin on 06/03/21.
//

import Foundation
import Alamofire
 
extension HOSPITALAPI {
    static func getProcedureList(handler: @escaping (_ exercise: [Procedure])->(), failureHandler: @escaping (_ errorMessage:String)->()){
        let url = URL(string: baseUrl + "/Appointment/json_procedures")!
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json"]).responseJSON(completionHandler: { data in
            debugPrint(String(data: data.data!, encoding: String.Encoding.utf8)!)
            if data.result.isSuccess {
                do {
                    let jsonData = try data.data!
                    let procedure: [Procedure] = try! JSONDecoder().decode([Procedure].self, from: jsonData)
                    handler(procedure)
                } catch {
                    print("Error: Couldn't parse JSON. \(error.localizedDescription)")
                }
            }else{
                failureHandler("Something went to wrong")
            }
        })
    }
}
