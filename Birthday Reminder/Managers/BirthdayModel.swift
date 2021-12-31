//
//  BirthdayModel.swift
//  Birthday Reminder
//
//  Created by Zeinab Khosravinia on 5/5/1400 AP.
//

import UIKit

class BirthdayModel: NSObject {
    var userId: String?
    var name: String?
    var birthday: Date?
    var preferedCalendar: Calendar = Calendar(identifier: .persian)
    var avatarImage: UIImage?
    var isFemale: Bool = true
    var upcomingDays: Int = 0
    var avatarImageName: String?

    override init() {
        super.init()
        
        avatarImage = getAvatar()
        upcomingDays = getRemainingDays() ?? 0
    }
    
    init(dic: NSDictionary?) {
        super.init()
        
        guard let dictionary = dic else {
            return
        }
        
        userId = dictionary["id"] as? String
        name = dictionary["name"] as? String
        isFemale = dictionary["isFemale"] as? Bool ?? true
        
        if let cal = dictionary["calendar"] as? String {
            if cal.lowercased() == "gregorian" {
                preferedCalendar = Calendar(identifier: .gregorian)
            }
        }
        
        if let date = dictionary["date"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = preferedCalendar
            dateFormatter.dateFormat = "yyyy-MM-dd"
            birthday = dateFormatter.date(from: date)
        }
        
        avatarImageName = dictionary["avatar"] as? String
        avatarImage = getAvatar()
        
        upcomingDays = getRemainingDays() ?? 0
    }
    
    
    init(string: String?) {
        super.init()
        
        guard let str = string else {
            return
        }
        
        let array = str.components(separatedBy: " ,")
        
        if array.count >= 3 {
            userId = UUID().uuidString
            
            name = array[0]
            
            isFemale = array[2].trimmingCharacters(in: .whitespacesAndNewlines) == "خانم"
            
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = preferedCalendar
            dateFormatter.dateFormat = "yyyy/MM/dd"
            let dateString = Utils.convertPersianNumbersToEnglish(string: array[1])
            birthday = dateFormatter.date(from: dateString)
            
            avatarImage = getAvatar()
            
            upcomingDays = getRemainingDays() ?? 0

        } else {
            return
        }
        

    }

    
    func makeDic() -> NSDictionary {
        let dic = NSMutableDictionary()

        dic.setObject(userId ?? UUID().uuidString, forKey:"id" as NSCopying)
        dic.setObject(name ?? "", forKey:"name" as NSCopying)
        dic.setValue(isFemale, forKey: "isFemale")
        dic.setObject(avatarImageName ?? "", forKey: "avatar" as NSCopying)
        dic.setObject(preferedCalendar.identifier == .persian ? "persian" : "gregorian", forKey: "calendar"  as NSCopying)
        dic.setObject(Utils.convertDateToString(format: "yyyy-MM-dd", date:birthday ?? Date()), forKey: "date"  as NSCopying)
        
        return dic
    }
    
    func convertDateToString() -> String? {
        if birthday != nil {
            return Utils.convertDateToString(format: "yyyy/MM/dd", date: birthday!)
        }
        
        return nil
    }
    
    func getRemainingDays() -> Int? {
        if birthday != nil {
            let currentYear = BirthdayManager.getCurrentYear(cal: preferedCalendar)
            
            var dateComponents: DateComponents? = preferedCalendar.dateComponents([.year, .month, .day], from: birthday ?? Date())

            dateComponents?.year = currentYear

            var upcomingBirthday: Date = preferedCalendar.date(from: dateComponents!) ?? Date()

            if upcomingBirthday < Date()  {

                dateComponents?.year = (currentYear ?? 0) + 1

                upcomingBirthday = preferedCalendar.date(from: dateComponents!) ?? Date()
                
            }

            return BirthdayManager.getDiffDays(from: Date(), to: upcomingBirthday, cal: preferedCalendar)

        }
        
        return nil
    }
    
    func getAvatar() -> UIImage? {
        if let image = UIImage(named: avatarImageName ?? "") {
            return image
        }
        
        if let image = BirthdayManager.getSavedImage(named: avatarImageName ?? "") {
            return image
        }
        
        return UIImage(named: isFemale ? "Female" : "Male")
    }
}
