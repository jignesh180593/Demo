//
//  COMMON.swift
//  Left_Drawer
//
//  Created by admin on 08/03/21.
//  Copyright © 2021 Romal Tandel. All rights reserved.
//

import Foundation
class COMMON{
   public static func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}
