//
//  DashboardApi.swift
//  Left_Drawer
//
//  Created by admin on 02/03/21.
//  Copyright © 2021 Romal Tandel. All rights reserved.
//

import Foundation
import Alamofire
 
extension HOSPITALAPI {
    static func getDashboarSliderData(handler: @escaping (_ exercise: [DashboardSlider])->(), failureHandler: @escaping (_ errorMessage:String)->()){
        
        let url = URL(string: baseUrl + "/slider/json")!
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json"]).responseJSON(completionHandler: { data in
            
            debugPrint(String(data: data.data!, encoding: String.Encoding.utf8)!)
            if data.result.isSuccess {
                do {
                    let jsonData = try data.data!
                    let sliderData: [DashboardSlider] = try! JSONDecoder().decode([DashboardSlider].self, from: jsonData)
                    handler(sliderData)
                } catch {
                    print("Error: Couldn't parse JSON. \(error.localizedDescription)")
                }
            }else{
                failureHandler("Something went to wrong")
            }
        })
    }
}
