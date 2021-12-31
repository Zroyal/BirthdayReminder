//
//  ViewController.swift
//  Birthday Reminder
//
//  Created by Zeinab Khosravinia on 5/4/1400 AP.
//

import UIKit
import AMTabView

class HomeVC: BaseVC, TabItem {

    @IBOutlet weak var tableView: UITableView!

    private var birthdayList: [BirthdayModel] = []
    private var todayList: [BirthdayModel] = []

    private var observer: NSObjectProtocol?

    var tabImage: UIImage? {
      return UIImage(named: "Home")
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView()
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        observer = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [unowned self] notification in
            self.reloadData()
        }

        reloadData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    func reloadData() {
        birthdayList = BirthdayManager.readBirthdays() ?? []
        todayList = birthdayList.filter { $0.upcomingDays == 0}
        tableView.reloadData()
    }

    private func customView() {
        UNUserNotificationCenter.current().delegate = self

        self.navigationController?.navigationBar.backgroundColor = UIColor.appDarkYellow()
        self.title = Strings.home
        
        tableView.estimatedRowHeight = 10
        tableView.estimatedSectionHeaderHeight = 10
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension

        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            
            switch notificationSettings.authorizationStatus {
            
            case .notDetermined:
                BirthdayManager.requestAuthorization(completionHandler: { (success) in
                    guard success else { return }

                })
                                
            case .denied:
                print("Application Not Allowed to Display Notifications")
                
                
            default:
                print("Application Not Allowed to Display Notifications")
            }
        }

    }
    
    private func deleteBirthday(birthday: BirthdayModel) {
        let alert = UIAlertController(title: nil, message: Strings.areYouSure, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: Strings.ok, style: .destructive, handler: { action in
            BirthdayManager.deleteBirthday(birthday: birthday)
            self.birthdayList = BirthdayManager.readBirthdays() ?? []
            self.todayList = self.birthdayList.filter { $0.upcomingDays == 0}
            self.tableView.reloadData()
        }
        ))
        
        alert.addAction(UIAlertAction(title: Strings.cancel, style: .default, handler: { action in
        }
        ))
        
        self.present(alert, animated: true, completion: nil)

    }
    
    private func showEditVC(birthday: BirthdayModel) {
        let vc: AddVC = self.storyboard?.instantiateViewController(identifier: "AddVC") as! AddVC
        vc.currentModel = birthday
        
        let navc = UINavigationController.init(rootViewController: vc)
        navc.modalPresentationStyle = .fullScreen
        self.present(navc, animated: true, completion: nil)
    }
    
    @objc func sayCongrate(sender: UIButton) {
        let name = todayList[sender.tag].name ?? ""
        let text = BirthdayManager.getCongragulationMessage(name: name)
        let textShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)

    }

}


extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if todayList.count > 0 {
                return todayList.count
            }
            
            return 1
        }
        
        else {
            if birthdayList.count > 0 {
                return birthdayList.count
            }
            
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if todayList.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell") as! EmptyCell
                cell.configCell()
                return cell
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TodayCell") as! TodayCell
                
                cell.configCell()
                
                let item = todayList[indexPath.row]
                cell.nameLabel.text = String(format: Strings.todayIsSomeoneBirthday, item.name!)
                cell.avatarImageView.image = item.avatarImage
                cell.congrateButton.tag = indexPath.row
                cell.congrateButton.addTarget(self,
                                              action: #selector(sayCongrate(sender:)),
                                              for: .touchUpInside)
                
                return cell

            }
        }
        
        
        if birthdayList.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyListCell") as! EmptyListCell
            cell.configCell()
            return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BirthdayCell") as! BirthdayCell
            cell.configCell()
            
            let item = birthdayList[indexPath.row]
            cell.nameLabel.text = item.name
            cell.avatarImageView.image = item.avatarImage
            cell.birthdayLabel.text = Utils.convertDateToString(format: "d MMMM", date: item.birthday!)
            
            if item.upcomingDays == 0 {
                cell.remaningDayCountLabel.text = Strings.todayBirthdays
                cell.remaningDayLabel.text = ""
                
            } else {
                cell.remaningDayCountLabel.text = "\(item.upcomingDays)"
                cell.remaningDayLabel.text = Strings.remaningDay
            }
                
            
            return cell

        }

    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as? HeaderCell
        
        cell?.configCell(isToday: section == 0)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if indexPath.section == 0 {
            return nil
        }
        
        
        let deleteItem = UIContextualAction(style: .normal, title: nil) {  (contextualAction, view, boolValue) in
            
            self.deleteBirthday(birthday: self.birthdayList[indexPath.row])
        }
        
        
        deleteItem.backgroundColor = UIColor.appLightYellow()
        deleteItem.image = UIImage(named: "Delete")

        let editItem = UIContextualAction(style: .normal, title: nil) {  (contextualAction, view, boolValue) in
            self.showEditVC(birthday: self.birthdayList[indexPath.row])

      }
        
        editItem.backgroundColor = UIColor.appLightYellow()
        editItem.image = UIImage(named: "Edit")


        let swipeActions = UISwipeActionsConfiguration(actions: [deleteItem, editItem])
        
        return swipeActions
        
    }
    
}


extension HomeVC: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if #available(iOS 14.0, *) {
            completionHandler([.alert, .badge, .banner])
        } else {
            completionHandler([.alert, .badge])
        }
    }

}
