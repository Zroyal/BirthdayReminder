//
//  Extensions.swift
//  Birthday Reminder
//
//  Created by Zeinab Khosravinia on 5/4/1400 AP.
//

import UIKit

extension UIColor {
    class func appLightYellow() -> UIColor {
        return UIColor(red: 255/255, green: 250/255, blue: 222/255, alpha: 1.0)
    }
    
    class func appDarkYellow() -> UIColor {
        return UIColor(red: 240/255, green: 230/255, blue: 180/255, alpha: 1.0)
    }
    
    class func appLightPink() -> UIColor {
        return UIColor(red: 217/255, green: 122/255, blue: 137/255, alpha: 0.2)
    }
    
    class func appDarkPink() -> UIColor {
        return UIColor(red: 217/255, green: 122/255, blue: 137/255, alpha: 1.0)
    }
}


extension UIFont {

    class func appFont(size: CGFloat) -> UIFont {
        return UIFont(name: "B Yekan", size: size) ?? UIFont.systemFont(ofSize: size)
    }

}

