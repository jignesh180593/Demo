//
//  TimeSlotApi.swift
//  Left_Drawer
//
//  Created by admin on 06/03/21.
//

import Foundation
import Alamofire
 
extension HOSPITALAPI {
    static func getTimeSlotList(handler: @escaping (_ exercise: TimeSlot)->(), failureHandler: @escaping (_ errorMessage:String)->()){
        let url = URL(string: baseUrl + "/Appointment/json_slots")!
        let id = UserDefaults.standard.string(forKey: CONSTANT.Doctor_id)
        let appointment_date = UserDefaults.standard.string(forKey: "appointment_date")
        Alamofire.request(url, method: .post, parameters: ["doctor_id":id,"appointment_date":appointment_date], encoding: JSONEncoding.default, headers: ["Content-Type":"application/json"]).responseJSON(completionHandler: { data in
            debugPrint(String(data: data.data!, encoding: String.Encoding.utf8)!)
            if data.result.isSuccess {
                do {
                    let jsonData = try data.data!
                    let timeSlot: TimeSlot = try! JSONDecoder().decode(TimeSlot.self, from: jsonData)
                    handler(timeSlot)
                } catch {
                    print("Error: Couldn't parse JSON. \(error.localizedDescription)")
                }
            }else{
                failureHandler("Something went to wrong")
            }
        })
    }
}
