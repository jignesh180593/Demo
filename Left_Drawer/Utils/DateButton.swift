//
//  DateButton.swift
//  Left_Drawer
//
//  Created by admin on 09/03/21.
//

import Foundation
class DateButton: UIButton {

    var dateView = UIView()
    var toolBarView = UIView()

    override var inputView: UIView {

        get {
            return self.dateView
        }
        set {
            self.dateView = newValue
            self.becomeFirstResponder()
        }

    }

   override var inputAccessoryView: UIView {
         get {
            return self.toolBarView
        }
        set {
            self.toolBarView = newValue
        }
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

}
