//
//  AppDelegate.swift
//  Birthday Reminder
//
//  Created by Zeinab Khosravinia on 5/4/1400 AP.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let attributes = [
            NSAttributedString.Key.font: UIFont(name: "B Yekan", size: 18)!,
            NSAttributedString.Key.foregroundColor: UIColor.appDarkPink()]
        
        UINavigationBar.appearance().titleTextAttributes = attributes

        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "B Yekan", size: 14)!], for: .normal
        )
        

        return true
    }


}

