//
//  DoctorApi.swift
//  Left_Drawer
//
//  Created by admin on 06/03/21.
//

import Foundation
import Alamofire
 
extension HOSPITALAPI {
    static func getDoctorList(handler: @escaping (_ exercise: [Doctor])->(), failureHandler: @escaping (_ errorMessage:String)->()){
        let url = URL(string: baseUrl + "/Appointment/json_docters")!
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json"]).responseJSON(completionHandler: { data in
            debugPrint(String(data: data.data!, encoding: String.Encoding.utf8)!)
            if data.result.isSuccess {
                do {
                    let jsonData = try data.data!
                    let doctor: [Doctor] = try! JSONDecoder().decode([Doctor].self, from: jsonData)
                    handler(doctor)
                } catch {
                    print("Error: Couldn't parse JSON. \(error.localizedDescription)")
                }
            }else{
                failureHandler("Something went to wrong")
            }
        })
    }
    static func getDoctorFeesList(handler: @escaping (_ exercise: [DoctorFees])->(), failureHandler: @escaping (_ errorMessage:String)->()){
        let url = URL(string: baseUrl + "/OpdCharge/json_opd_charge")!
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json"]).responseJSON(completionHandler: { data in
            debugPrint(String(data: data.data!, encoding: String.Encoding.utf8)!)
            if data.result.isSuccess {
                do {
                    let jsonData = try data.data!
                    let doctor: [DoctorFees] = try! JSONDecoder().decode([DoctorFees].self, from: jsonData)
                    handler(doctor)
                } catch {
                    print("Error: Couldn't parse JSON. \(error.localizedDescription)")
                }
            }else{
                failureHandler("Something went to wrong")
            }
        })
    }
}
