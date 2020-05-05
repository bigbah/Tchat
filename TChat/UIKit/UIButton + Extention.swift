//
//  UIButton + Extention.swift
//  TChat
//
//  Created by Ostap Andreykiv on 04.05.2020.
//  Copyright © 2020 MI Future Tech. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    convenience init(title: String,
                     titleColor: UIColor,
                     backgroundColor: UIColor,
                     font: UIFont? = .avenir20(),
                     isShadow: Bool = false,
                     cornerrRadius: CGFloat = 4) {
        self.init(type: .system)
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.titleLabel?.font = font
        
        self.layer.cornerRadius = cornerrRadius
        
        if isShadow {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowRadius = 4
            self.layer.shadowOpacity = 0.2
            self.layer.shadowOffset = CGSize(width: 0, height: 4)
        }
        
    }
    
    func customizeGoogleButton() {
          let googleLogo = UIImageView(image: #imageLiteral(resourceName: "plus"), contentMode: .scaleAspectFill)
          
          googleLogo.translatesAutoresizingMaskIntoConstraints = false
          
          NSLayoutConstraint.activate([
          googleLogo.heightAnchor.constraint(equalToConstant: 40),
          googleLogo.widthAnchor.constraint(equalToConstant: 40)
                 ])
          
          self.addSubview(googleLogo)
          googleLogo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
          googleLogo.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
          
      }
      
      func customizeEmailButton() {
          let emailLogo = UIImageView(image: #imageLiteral(resourceName: "Blue-Email-PNG"), contentMode: .scaleAspectFill)
          
          emailLogo.translatesAutoresizingMaskIntoConstraints = false
          
          NSLayoutConstraint.activate([
          emailLogo.heightAnchor.constraint(equalToConstant: 40),
          emailLogo.widthAnchor.constraint(equalToConstant: 40)
                 ])
          
          self.addSubview(emailLogo)
          emailLogo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
          emailLogo.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
          
      }
}
