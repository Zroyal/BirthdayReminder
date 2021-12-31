//
//  SettingsVC.swift
//  Birthday Reminder
//
//  Created by Zeinab Khosravinia on 5/4/1400 AP.
//

import UIKit
import AMTabView

class SettingsVC: BaseVC, TabItem {
    @IBOutlet weak var messageContainer: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var part1Label: UILabel!
    @IBOutlet weak var part2Label: UILabel!
    @IBOutlet weak var finalLabel: UILabel!
    @IBOutlet weak var part1TextView: UITextView!
    @IBOutlet weak var part2TextView: UITextView!
    @IBOutlet weak var messageButton: UIButton!

    @IBOutlet weak var hourContainer: UIView!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var hourPicker: UIPickerView!
    @IBOutlet weak var hourButton: UIButton!

    @IBOutlet weak var messageAvatar: UIImageView!
    @IBOutlet weak var hourAvatar: UIImageView!

    @IBOutlet weak var importButton: UIButton!
    @IBOutlet weak var exportButton: UIButton!

    @IBOutlet weak var versionLabel: UILabel!


    var tabImage: UIImage? {
      return UIImage(named: "Settings")
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        customView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let hour = BirthdayManager.getNotificationHour()
        hourPicker.selectRow(hour-1, inComponent: 0, animated: true)

        let msg = BirthdayManager.getCongragulationMessage(name: "جان اسمیت")
        let parts = msg.components(separatedBy: "جان اسمیت")
        part1TextView.text = parts[0]
        part2TextView.text = parts[1]
        
        finalLabel.text = msg

    }
    
    private func customView() {
        self.navigationController?.navigationBar.backgroundColor = UIColor.appDarkYellow()
        self.title = Strings.settings
        
        messageContainer.layer.cornerRadius = 8.0
        messageContainer.layer.masksToBounds = true
        messageContainer.backgroundColor = UIColor.appLightPink()

        hourContainer.layer.cornerRadius = 8.0
        hourContainer.layer.masksToBounds = true
        hourContainer.backgroundColor = UIColor.appLightPink()
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        versionLabel.text = String(format: Strings.version, appVersion!)
        versionLabel.textColor = .gray
        versionLabel.font = UIFont.appFont(size: 12.0)
        
        hourLabel.text = "\(Strings.notifTime):"
        hourLabel.textColor = .darkGray
        hourLabel.font = UIFont.appFont(size: 16.0)

        messageLabel.text = Strings.defaultMessage
        messageLabel.textColor = .darkGray
        messageLabel.font = UIFont.appFont(size: 16.0)

        part1Label.text = Strings.defaultMessagePart1
        part1Label.textColor = .gray
        part1Label.font = UIFont.appFont(size: 14.0)

        part2Label.text = Strings.defaultMessagePart2
        part2Label.textColor = .gray
        part2Label.font = UIFont.appFont(size: 14.0)

        finalLabel.text = "\(Strings.defaultMessage):"
        finalLabel.textColor = .darkGray
        finalLabel.font = UIFont.appFont(size: 14.0)


        part1TextView.font = UIFont.appFont(size: 14.0)
        part1TextView.layer.cornerRadius = 4.0
        
        part2TextView.font = UIFont.appFont(size: 14.0)
        part2TextView.layer.cornerRadius = 4.0
        
        messageButton.layer.cornerRadius = 8.0
        messageButton.layer.masksToBounds = true
        messageButton.backgroundColor = UIColor.appDarkPink()
        messageButton.setTitle(Strings.save, for: .normal)
        messageButton.titleLabel?.font = UIFont.appFont(size: 14.0)
        messageButton.addTarget(self, action: #selector(saveMessage), for: .touchUpInside)
        
        hourButton.layer.cornerRadius = 8.0
        hourButton.layer.masksToBounds = true
        hourButton.backgroundColor = UIColor.appDarkPink()
        hourButton.setTitle(Strings.save, for: .normal)
        hourButton.titleLabel?.font = UIFont.appFont(size: 14.0)
        hourButton.addTarget(self, action: #selector(saveHour), for: .touchUpInside)

        makeCloseToolbar(textField: self.part1TextView)
        makeCloseToolbar(textField: self.part2TextView)
        
        hourPicker.delegate = self
        hourPicker.dataSource = self

        messageAvatar.layer.cornerRadius = messageAvatar.frame.width/2
        messageAvatar.layer.masksToBounds = true
        messageAvatar.layer.borderWidth = 1.0
        messageAvatar.layer.borderColor = UIColor.appDarkPink().cgColor
        messageAvatar.backgroundColor = .clear

        hourAvatar.layer.cornerRadius = hourAvatar.frame.width/2
        hourAvatar.layer.masksToBounds = true
        hourAvatar.layer.borderWidth = 1.0
        hourAvatar.layer.borderColor = UIColor.appDarkPink().cgColor
        hourAvatar.backgroundColor = .clear
        
        exportButton.setTitle(Strings.exportTitle, for: .normal)
        exportButton.layer.cornerRadius = 8.0
        exportButton.layer.masksToBounds = true
        exportButton.backgroundColor = UIColor.appDarkPink()
        exportButton.titleLabel?.font = UIFont.appFont(size: 14.0)
        exportButton.addTarget(self, action: #selector(exportList), for: .touchUpInside)

        importButton.setTitle(Strings.importTitle, for: .normal)
        importButton.layer.cornerRadius = 8.0
        importButton.layer.masksToBounds = true
        importButton.backgroundColor = UIColor.appDarkPink()
        importButton.titleLabel?.font = UIFont.appFont(size: 14.0)
        importButton.addTarget(self, action: #selector(importList), for: .touchUpInside)

    }
    
    private func makeCloseToolbar(textField : UITextView) {
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.sizeToFit()
        
        let flexibleLeft = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let close = UIBarButtonItem(
            title: Strings.close,
            style: .plain,
            target: self,
            action: #selector(close))
        
        toolbar.items = [flexibleLeft, close]
        textField.inputAccessoryView = toolbar
    }

    
    @objc func saveMessage() {
        self.view.endEditing(true)
        BirthdayManager.saveCongragulationMessage(msg: "\(part1TextView.text ?? "") %@ \(part2TextView.text ?? "")")
        let msg = BirthdayManager.getCongragulationMessage(name: "جان اسمیت")
        finalLabel.text = msg
        Utils().showSettingsSuccess(message: Strings.settingSaved)
    }

    
    @objc func saveHour() {
        self.view.endEditing(true)
        let hour = self.hourPicker.selectedRow(inComponent: 0) + 1
        BirthdayManager.saveNotificationHour(hour: hour)
        Utils().showSettingsSuccess(message: Strings.settingSaved)
    }
    
    
    @objc func exportList() {
        if let birthdays = BirthdayManager.readBirthdays() {
            let objectsToShare = [BirthdayManager.createCSV(from: birthdays)]

            let activityVC = UIActivityViewController(activityItems: objectsToShare as [Any], applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
    }

    
    @objc func importList() {
        let importMenu = UIDocumentPickerViewController(documentTypes: ["public.comma-separated-values-text"], in: .import)
        importMenu.delegate = self
        self.present(importMenu, animated: true, completion: nil)
    }


    @objc func close() {
        self.view.endEditing(true)
    }


    private func handleCSVFile(url: URL) -> [BirthdayModel]? {
        if let data = try? String(contentsOf: url) {
            var result: [BirthdayModel] = []
            let rows = data.components(separatedBy: "\n")
            var ind = 0
            
            for row in rows {
                if ind != 0 {
                    let model = BirthdayModel(string: row)
                    if model.userId != nil {
                        result.append(model)
                    }
                }
                
                ind += 1
            }
            
            return result
        } else {
            return nil
        }
    }

    func showAddDialogue(list: [BirthdayModel]) {
        let message = String(format: Strings.addFromListAlertMessage, list.count)
        let title = Strings.importTitle
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: Strings.addToCurrentList, style: .default, handler: { action in
            
            for item in list {
                BirthdayManager.addBirthdayToList(birthday: item)
            }
            
            Utils().showSuccess(message: Strings.successImportAlert)

        }
        ))
        
        
        alert.addAction(UIAlertAction(title: Strings.replaceWithCurrentList, style: .default, handler: { action in
            
            BirthdayManager.deleteAllBirthdays()
            
            for item in list {
                BirthdayManager.addBirthdayToList(birthday: item)
            }
            
            Utils().showSuccess(message: Strings.successImportAlert)
        }
        ))
           
        
        alert.addAction(UIAlertAction(title: Strings.cancel, style: .cancel, handler: { action in
        }
        ))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showImportError() {
        let message = Strings.invalidCSVFormat
        let title = Strings.importTitle
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: Strings.cancel, style: .default, handler: { action in
        }
        ))
        
        self.present(alert, animated: true, completion: nil)
    }

}

extension SettingsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 24
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row+1)"
    }
}



extension SettingsVC: UIDocumentPickerDelegate {
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
           return
        }
        
        
        if let birthdays = handleCSVFile(url: myURL) {
            if birthdays.count > 0 {
                showAddDialogue(list: birthdays)
            } else {
               showImportError()
            }
        } else {
            showImportError()
        }
    }
    
}
