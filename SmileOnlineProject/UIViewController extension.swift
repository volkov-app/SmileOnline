//
//  UIView extension.swift
//  SmileOnlineProject
//
//  Created by Alex Rudoi on 26/5/21.
//

import UIKit

extension UIViewController {
    
    @available(iOS 10, *)
    func openUrl(urlStr:String!) {
        if let url = URL(string:urlStr) {
            UIApplication.shared.openURL(url)
        }
    }
}
