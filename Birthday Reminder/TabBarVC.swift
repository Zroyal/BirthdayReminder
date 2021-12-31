//
//  TabBarVC.swift
//  Birthday Reminder
//
//  Created by Zeinab Khosravinia on 5/4/1400 AP.
//

import UIKit
import AMTabView

class TabBarVC: AMTabsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        customTabbar()

        setTabsControllers()
    }
    
    private func setTabsControllers() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeVC")
        let navcHome = UINavigationController(rootViewController: homeVC)

        let addVC = storyboard.instantiateViewController(withIdentifier: "AddVC")
        let navcAdd = UINavigationController(rootViewController: addVC)

        let settingsVC = storyboard.instantiateViewController(withIdentifier: "SettingsVC")
        let navcSettings = UINavigationController(rootViewController: settingsVC)

      viewControllers = [
        navcHome,
        navcAdd,
        navcSettings
      ]
    }
    
    private func customTabbar() {
        AMTabView.settings.ballColor = UIColor.appDarkPink()
        AMTabView.settings.tabColor = UIColor.appDarkYellow()
        AMTabView.settings.unSelectedTabTintColor =  UIColor.appDarkPink()

        AMTabView.settings.animationDuration = 0.5

    }


}
