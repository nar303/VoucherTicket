//
//  Utils.swift
//  VoucherTicket
//
//  Created by Narek Ghukasyan on 21.08.22.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
           assert(red >= 0 && red <= 255, "Invalid red component")
           assert(green >= 0 && green <= 255, "Invalid green component")
           assert(blue >= 0 && blue <= 255, "Invalid blue component")

           self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
       }

       convenience init(hex: Int) {
           self.init(
               red: (hex >> 16) & 0xFF,
               green: (hex >> 8) & 0xFF,
               blue: hex & 0xFF
           )
       }
}

@IBDesignable
extension UITextField {
    
    @IBInspectable var paddingLeftCustom: CGFloat {
        get {
            return leftView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            if leftView == nil {
                leftView = paddingView
                leftViewMode = .always
            }
            
        }
    }

    @IBInspectable var paddingRightCustom: CGFloat {
        get {
            return rightView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            if rightView == nil {
                rightView = paddingView
                rightViewMode = .always
            }
            
        }
    }
}

