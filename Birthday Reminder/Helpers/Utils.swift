//
//  Utils.swift
//  Birthday Reminder
//
//  Created by Zeinab Khosravinia on 5/5/1400 AP.
//

import UIKit
import SwiftMessages

class Utils: NSObject {
    class func convertDateToString(format: String, date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .persian)
        dateFormatter.locale = Locale(identifier: "fa_IR")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    class func showError(message: String) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureContent(
            title: Strings.error,
            body: message,
            iconText: "⚠️")

        view.backgroundView.backgroundColor = UIColor.appLightYellow()
        
        view.titleLabel?.font = UIFont.appFont(size: 16.0)
        
        view.bodyLabel?.textColor = .darkGray
        view.bodyLabel?.font = UIFont.appFont(size: 14.0)
        
        view.button?.isHidden = true
        
        var config = SwiftMessages.Config()

        config.presentationStyle = .bottom
        config.presentationContext = .window(windowLevel: .statusBar)
        config.prefersStatusBarHidden = false
        config.duration = .automatic
        config.dimMode = .gray(interactive: true)
        config.interactiveHide = true
        config.eventListeners.append() { event in
            if case .didHide = event { print("yep") }
        }

        SwiftMessages.show(config: config, view: view)
    }
    
    
    func showSuccess(message: String) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureContent(
            title: "",
            body: message,
            iconText: "🎉")

        view.backgroundView.backgroundColor = UIColor.appLightYellow()
        
        view.titleLabel?.font = UIFont.appFont(size: 16.0)
        
        view.bodyLabel?.textColor = .darkGray
        view.bodyLabel?.font = UIFont.appFont(size: 16.0)
        
        view.button?.isHidden = true

        var config = SwiftMessages.Config()

        config.presentationStyle = .bottom
        config.presentationContext = .window(windowLevel: .statusBar)
        config.prefersStatusBarHidden = false
        config.duration = .automatic
        config.dimMode = .gray(interactive: true)
        config.interactiveHide = true
        config.eventListeners.append() { event in
            if case .didHide = event { print("yep") }
        }

        SwiftMessages.show(config: config, view: view)
    }
    
    func showSettingsSuccess(message: String) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureContent(
            title: "",
            body: message,
            iconText: "🛠")

        view.backgroundView.backgroundColor = UIColor.appLightYellow()
        
        view.titleLabel?.font = UIFont.appFont(size: 16.0)
        
        view.bodyLabel?.textColor = .darkGray
        view.bodyLabel?.font = UIFont.appFont(size: 16.0)
        
        view.button?.isHidden = true

        var config = SwiftMessages.Config()

        config.presentationStyle = .bottom
        config.presentationContext = .window(windowLevel: .statusBar)
        config.prefersStatusBarHidden = false
        config.duration = .automatic
        config.dimMode = .gray(interactive: true)
        config.interactiveHide = true
        config.eventListeners.append() { event in
            if case .didHide = event { print("yep") }
        }

        SwiftMessages.show(config: config, view: view)
    }

    
    class func convertPersianNumbersToEnglish(string: String?) -> String {
        var final = string ?? ""
        final = final.replacingOccurrences(of: "٠", with: "0")
        final = final.replacingOccurrences(of: "١", with: "1")
        final = final.replacingOccurrences(of: "٢", with: "2")
        final = final.replacingOccurrences(of: "٣", with: "3")
        final = final.replacingOccurrences(of: "٤", with: "4")
        final = final.replacingOccurrences(of: "٥", with: "5")
        final = final.replacingOccurrences(of: "٦", with: "6")
        final = final.replacingOccurrences(of: "٧", with: "7")
        final = final.replacingOccurrences(of: "٨", with: "8")
        final = final.replacingOccurrences(of: "٩", with: "9")

        final = final.replacingOccurrences(of: "۰", with: "0")
        final = final.replacingOccurrences(of: "۱", with: "1")
        final = final.replacingOccurrences(of: "۲", with: "2")
        final = final.replacingOccurrences(of: "۳", with: "3")
        final = final.replacingOccurrences(of: "۴", with: "4")
        final = final.replacingOccurrences(of: "۵", with: "5")
        final = final.replacingOccurrences(of: "۶", with: "6")
        final = final.replacingOccurrences(of: "۷", with: "7")
        final = final.replacingOccurrences(of: "۸", with: "8")
        final = final.replacingOccurrences(of: "۹", with: "9")

        return final
    }

}
