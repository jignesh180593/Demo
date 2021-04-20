//
//  Extentions.swift
//  Left_Drawer
//
//  Created by admin on 10/03/21.
//  Copyright © 2021 Romal Tandel. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func isEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-z0-9](\\.?[a-z0-9_-]){0,}@[a-z0-9-]+\\.([a-z]{1,6}\\.)?[a-z]{2,6}$",
                                             options: [.caseInsensitive])
        
        return regex.firstMatch(in: self, options: [],
                                range: NSMakeRange(0, utf16.count)) != nil
    }
}
extension UIImageView {
    func downloadImageFromUrl(_ url: String, defaultImage: UIImage? = UIImage(named: "photo")) {
         guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) -> Void in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    return
            }
            DispatchQueue.main.async {
                self?.image = image
            }
        }).resume()
    }
}

