//
//  BirthdayManager.swift
//  Birthday Reminder
//
//  Created by Zeinab Khosravinia on 5/5/1400 AP.
//

import UIKit
import UserNotifications

class BirthdayManager: NSObject {
    
    class func readBirthdays() -> [BirthdayModel]? {
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        initBirthdaysIfNeeded()
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        let path = documentsDirectory.appendingPathComponent("userBirthdays.plist")
        
        let list = NSArray(contentsOfFile: path)
        
        var finalList: [BirthdayModel] = []
        
        if list != nil {
            for item in list as! [NSDictionary] {
                let model = BirthdayModel(dic: item)
                finalList.append(model)
                
                if item["id"] == nil || (item["id"] as? String) == "" {
                    model.userId = UUID().uuidString
                    updateBirthday(birthday: model)
                }
            }
        }
        
        setLocalNotificationForList(list: finalList)
        return finalList.sorted(by: { $0.upcomingDays <= $1.upcomingDays })
        
    }
    
    class func getCurrentYear(cal: Calendar) -> Int? {
        let dateComponents: DateComponents? = cal.dateComponents([.year], from: Date())
        
        return dateComponents?.year
    }
    
    
    class func getDiffDays(from: Date, to: Date, cal: Calendar) -> Int {
        let fromDate = cal.startOfDay(for: from)
        let toDate = cal.startOfDay(for: to)
        
        let fromComponents: DateComponents? = cal.dateComponents([.month, .day], from: from)
        let toComponents: DateComponents? = cal.dateComponents([.month, .day], from: to)
        
        if fromComponents?.day == toComponents?.day && fromComponents?.month == toComponents?.month {
            return 0
        }
        
        
        let numberOfDays = cal.dateComponents([.day], from: fromDate, to: toDate)
        
        return numberOfDays.day!
        
    }
    
    class func addBirthdayToList(birthday: BirthdayModel) {
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        let path = documentsDirectory.appendingPathComponent("userBirthdays.plist")
        
        var list: NSArray? = NSArray(contentsOfFile: path)
        
        let dic = birthday.makeDic()
        list = NSArray(array: list?.adding(dic) ?? [])
        
        list?.write(toFile: path, atomically: false)
        
    }
    
    class func updateBirthday(birthday: BirthdayModel) {
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        let path = documentsDirectory.appendingPathComponent("userBirthdays.plist")
        
        let list: NSArray? = NSArray(contentsOfFile: path)
        
        let newList = NSMutableArray()
        
        if list != nil {
            for item in list as! [NSDictionary] {
                if (item["id"] as? String) == birthday.userId {
                    let newItem = birthday.makeDic()
                    newList.add(newItem)
                    
                } else {
                    newList.add(item)
                }
            }
        }
        
        
        newList.write(toFile: path, atomically: false)
    }
    
    class func deleteBirthday(birthday: BirthdayModel) {
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        let path = documentsDirectory.appendingPathComponent("userBirthdays.plist")
        
        let list: NSArray? = NSArray(contentsOfFile: path)
        
        let newList = NSMutableArray()
        
        if list != nil {
            for item in list as! [NSDictionary] {
                if (item["id"] as? String) != birthday.userId {
                    newList.add(item)
                }
            }
        }
        
        
        newList.write(toFile: path, atomically: false)
    }
    
    
    class func deleteAllBirthdays() {
        if let allBirthdays = readBirthdays() {
            for item in allBirthdays {
                deleteBirthday(birthday: item)
            }
        }
    }
    
    
    class func saveImage(image: UIImage, name: String) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent("\(name).png")!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    
    class func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
    
    class func initBirthdaysIfNeeded() {
        if !UserDefaults.standard.bool(forKey: "defaultRead") {
            
            UserDefaults.standard.setValue(true, forKey: "defaultRead")
            UserDefaults.standard.synchronize()
            
            var list: NSArray?
            if let path = Bundle.main.path(forResource: "Birthdays", ofType: "plist") {
                list = NSArray(contentsOfFile: path)
                
                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
                let documentsDirectory = paths.object(at: 0) as! NSString
                let newPath = documentsDirectory.appendingPathComponent("userBirthdays.plist")
                
                list?.write(toFile: newPath, atomically: false)
            }
        }
        
    }
    
    
    class func getCongragulationMessage(name: String) -> String {
        var msg = Strings.defaultCongrateMessage
        
        if UserDefaults.standard.value(forKey: "customCongratulationMessage") != nil {
            msg = UserDefaults.standard.value(forKey: "customCongratulationMessage") as! String
        }
        
        return String(format: msg, name)
    }
    
    class func saveCongragulationMessage(msg: String) {
        UserDefaults.standard.setValue(msg, forKey: "customCongratulationMessage")
        UserDefaults.standard.synchronize()
    }
    
    class func setLocalNotificationForList(list: [BirthdayModel]) {
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        for item in list {
            let content = UNMutableNotificationContent()
            content.title = String(format: Strings.notificationMessage, item.name ?? "")
            content.sound = .default
            content.badge = 1
            
            var dateComponents: DateComponents? = Calendar.current.dateComponents(
                [.year, .month, .day],
                from: item.birthday ?? Date())
            
            dateComponents?.year = getCurrentYear(cal: Calendar.current)
            dateComponents?.hour = getNotificationHour()
            dateComponents?.minute = 0
            
            
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: dateComponents!,
                repeats: false)
            
            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(
                identifier: uuidString,
                content: content,
                trigger: trigger)
            
            
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.add(request) { (error) in
                if error != nil {
                    // Handle any errors.
                }
            }
            
        }
        
    }
    
    
    class func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }
            
            completionHandler(success)
        }
    }
    
    class func getNotificationHour() -> Int {
        
        if UserDefaults.standard.value(forKey: "NotificationHour") != nil {
            return UserDefaults.standard.value(forKey: "NotificationHour") as! Int
        }
        
        return 10
    }
    
    class func saveNotificationHour(hour: Int) {
        UserDefaults.standard.setValue(hour, forKey: "NotificationHour")
        UserDefaults.standard.synchronize()
        _ = readBirthdays()
    }
    
    
    class func createCSV(from array:[BirthdayModel]) -> URL? {
        var csvString = "\("Name"),\("BirthDate"),\("Gender")\n"
        for model in array {
            let name = model.name ?? "_"
            let birthdate = model.convertDateToString() ?? "_"
            let gender = model.isFemale ? "خانم" : "آقا"
            csvString = csvString.appending("\(name) ,\(birthdate) ,\(gender)\n")
        }
        
        let fileManager = FileManager.default
        do {
            let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let fileURL = path.appendingPathComponent("birthdays.csv")
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            
            return fileURL
        } catch {
            print("error creating file")
        }
        
        return nil
    }
    
}
