//
//  ActivityIndicator.swift
//  Left_Drawer
//
//  Created by admin on 09/03/21.
//

import Foundation
import UIKit

class ActivityIndicator {
    
    static var activityIndicator = UIActivityIndicatorView()
    static var strLabel = UILabel()
    
    static let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    static func activityIndicator(_ title: String,parentView:UIView) {
        
        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
        
        effectView.frame = CGRect(x: 0, y: 0 , width: parentView.frame.width, height: parentView.frame.height)
        effectView.layer.masksToBounds = true
        
        if #available(iOS 13.0, *) {
            activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        } else {
            // Fallback on earlier versions
            activityIndicator = UIActivityIndicatorView(style: .gray)
        }
        activityIndicator.frame = CGRect(x: parentView.frame.width/2, y: parentView.frame.height/2, width: 46, height: 46)
        activityIndicator.startAnimating()
        
        strLabel = UILabel(frame: CGRect(x: activityIndicator.frame.origin.x + 50, y: parentView.frame.height/2 - 20, width: 160, height: 46))
        strLabel.text = title
        strLabel.font = .systemFont(ofSize: 14, weight: .medium)
        strLabel.textColor = UIColor.black
        
        
        effectView.contentView.addSubview(activityIndicator)
       // effectView.contentView.addSubview(strLabel)
        parentView.addSubview(effectView)
    }
    
    static func removeActivityIndicator(){
        effectView.removeFromSuperview()
    }
}
