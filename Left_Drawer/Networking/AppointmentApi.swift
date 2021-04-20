//
//  AppointmentApi.swift
//  Left_Drawer
//
//  Created by admin on 08/03/21.
//

import Foundation
import Alamofire

extension HOSPITALAPI {
     static func sentPatientData(appointment:Appointment,successHandler: @escaping (_ message:String)->(), failureHandler: @escaping (_ errorMessage:String)->()) {
            let url = URL(string: baseUrl + "/Appointment/patientinfo")!
        Alamofire.request(url, method: .post, parameters: ["patient_name":appointment.Name,"age":appointment.Age,"sex":appointment.Gender,"address":appointment.Address,"district":appointment.District,"swd":appointment.SOWO,"mobile":appointment.Mobile,"bp":appointment.BP,"diabetes":appointment.Diabetes], encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseJSON(completionHandler: { data in
               if data.result.isSuccess {
                    print(NSString(data: data.data!, encoding: String.Encoding.utf8.rawValue) ?? "Kobaja")
                do {
                    let jsonData = try data.data!
                    let pentintResult: PentintResult = try! JSONDecoder().decode(PentintResult.self, from: jsonData)
                    if pentintResult.result == "300"{
                        UserDefaults.standard.setValue(pentintResult.id, forKey: CONSTANT.patient_id)
                        successHandler(pentintResult.message!)
                    }
                } catch {
                    print("Error: Couldn't parse JSON. \(error.localizedDescription)")
                }
                }else{
                   failureHandler("Something went to wrong")
               }
           })
       }
    static func sentAppointInfoData(appointment:Appointment,successHandler: @escaping (_ message:String)->(), failureHandler: @escaping (_ errorMessage:String)->()) {
           let url = URL(string: baseUrl + "/Appointment/appointmentinfo")!
        guard let user_id = UserDefaults.standard.string(forKey: CONSTANT.User_id) else {
            return
        }
        Alamofire.request(url, method: .post, parameters: ["appointment_date":appointment.appointment_date,"patient_id":appointment.patient_id,"docter_id":appointment.docter_id,"procedure_id":appointment.procedure_id,"slot_time":appointment.slot_time,"user_id":user_id], encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseJSON(completionHandler: { data in
              if data.result.isSuccess {
                   print(NSString(data: data.data!, encoding: String.Encoding.utf8.rawValue) ?? "Kobaja")
               do {
                   let jsonData = try data.data!
                   let pentintResult: PentintResult = try! JSONDecoder().decode(PentintResult.self, from: jsonData)
                   if pentintResult.result == "300"{
                       UserDefaults.standard.setValue(pentintResult.id, forKey: CONSTANT.patient_id)
                       successHandler(pentintResult.message!)
                   }
               } catch {
                   print("Error: Couldn't parse JSON. \(error.localizedDescription)")
               }
               }else{
                  failureHandler("Something went to wrong")
              }
          })
      }
    static func getDoctorAppointmentListData(handler: @escaping (_ exercise: [AppointmentListDoctor])->(), failureHandler: @escaping (_ errorMessage:String)->()){
        let url = URL(string: baseUrl + "/Docters/appointments")!
        guard let doctor_id = UserDefaults.standard.string(forKey: CONSTANT.Doctor_id) else {
            return
        }
        Alamofire.request(url, method: .post, parameters: ["doctor_id":doctor_id], encoding: JSONEncoding.default, headers: ["Content-Type":"application/json"]).responseJSON(completionHandler: { data in
            debugPrint(String(data: data.data!, encoding: String.Encoding.utf8)!)
            if data.result.isSuccess {
                do {
                    let jsonData = try data.data!
                    let DoctorAppointmentListData: [AppointmentListDoctor] = try! JSONDecoder().decode([AppointmentListDoctor].self, from: jsonData)
                    handler(DoctorAppointmentListData)
                } catch {
                    print("Error: Couldn't parse JSON. \(error.localizedDescription)")
                }
            }else{
                failureHandler("Something went to wrong")
            }
        })
    }
    static func getFilterDoctorAppointmentListData(start_date:String,end_date:String,handler: @escaping (_ exercise: [AppointmentListDoctor])->(), failureHandler: @escaping (_ errorMessage:String)->()){
        let url = URL(string: baseUrl + "/Docters/filter_appointments")!
        guard let doctor_id = UserDefaults.standard.string(forKey: CONSTANT.Doctor_id) else {
            return
        }
        Alamofire.request(url, method: .post, parameters: ["doctor_id":doctor_id,"start_date":start_date,"end_date":end_date], encoding: JSONEncoding.default, headers: ["Content-Type":"application/json"]).responseJSON(completionHandler: { data in
            debugPrint(String(data: data.data!, encoding: String.Encoding.utf8)!)
            if data.result.isSuccess {
                do {
                    let jsonData = try data.data!
                    let DoctorAppointmentListData: [AppointmentListDoctor] = try! JSONDecoder().decode([AppointmentListDoctor].self, from: jsonData)
                    handler(DoctorAppointmentListData)
                } catch {
                    print("Error: Couldn't parse JSON. \(error.localizedDescription)")
                }
            }else{
                failureHandler("Something went to wrong")
            }
        })
    }
    static func getMyAppointmentListData(handler: @escaping (_ exercise: [MyAppointment])->(), failureHandler: @escaping (_ errorMessage:String)->()){
        let url = URL(string: baseUrl + "/Appointment/allapointments")!
        guard let user_id = UserDefaults.standard.string(forKey: CONSTANT.User_id) else {
            return
        }
        Alamofire.request(url, method: .post, parameters: ["user_id":user_id], encoding: JSONEncoding.default, headers: ["Content-Type":"application/json"]).responseJSON(completionHandler: { data in
            debugPrint(String(data: data.data!, encoding: String.Encoding.utf8)!)
            if data.result.isSuccess {
                do {
                    let jsonData = try data.data!
                    let MyAppointmentListData: [MyAppointment] = try! JSONDecoder().decode([MyAppointment].self, from: jsonData)
                    handler(MyAppointmentListData)
                } catch {
                    print("Error: Couldn't parse JSON. \(error.localizedDescription)")
                }
            }else{
                failureHandler("Something went to wrong")
            }
        })
    }
}
