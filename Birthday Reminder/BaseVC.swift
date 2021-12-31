//
//  BaseVC.swift
//  Birthday Reminder
//
//  Created by Zeinab Khosravinia on 12/31/21.
//

import UIKit

class BaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBarColor()
    }

    func setNavBarColor() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.appFont(size: 18.0)]
        appearance.backgroundColor = UIColor.appDarkYellow()
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance

    }
}
