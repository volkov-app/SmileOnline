//
//  UIView extention.swift
//  SmileOnlineProject
//
//  Created by Алексей Волков on 22.05.2021.
//

import UIKit

extension UIView {
    func dropShadow() {
        layer.shadowColor = UIColor.blue.cgColor
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.3
        }
    
    func textFieldUI() {
        layer.borderColor = UIColor.blue.cgColor
        layer.cornerRadius = 5.0
        layer.borderWidth = 1.0
        layer.masksToBounds = true
    }
}
