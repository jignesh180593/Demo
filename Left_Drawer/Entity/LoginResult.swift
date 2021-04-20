//
//  LoginResult.swift
//  Left_Drawer
//
//  Created by admin on 08/03/21.
//

import Foundation

struct LoginResult : Decodable {
    let result : String?
    let message : String?
    let firstname : String?
    let lastname : String?
    let user_email : String?
    let user_mobile : String?
    let user_id : String?
 }
