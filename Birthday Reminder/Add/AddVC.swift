//
//  AddVC.swift
//  Birthday Reminder
//
//  Created by Zeinab Khosravinia on 5/4/1400 AP.
//

import UIKit
import AMTabView

class AddVC: BaseVC, TabItem, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameContainer: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameAvatar: UIImageView!
    
    @IBOutlet weak var birthdayContainer: UIView!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var birthdayAvatar: UIImageView!
    
    @IBOutlet weak var genderContainer: UIView!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var maleLabel: UILabel!
    @IBOutlet weak var femaleLabel: UILabel!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var genderAvatar: UIImageView!
    
    @IBOutlet weak var profileContainer: UIView!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var profileAvatar: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    private var imagePicker = UIImagePickerController()
    private var isEditMode: Bool = false
    
    var currentModel: BirthdayModel?
    
    var tabImage: UIImage? {
        return UIImage(named: "Add")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView()
        
        if currentModel == nil {
            currentModel = BirthdayModel()
        } else {
            isEditMode = true
            nameTextField.text = currentModel?.name
            birthdayTextField.text = currentModel?.convertDateToString()
            profileImageView.image = currentModel?.avatarImage
            
            rightButton.setTitle(Strings.close, for: .normal)
            rightButton.addTarget(self, action: #selector(closeVC), for: .touchUpInside)

        }
        
        customGender(genderButton: femaleButton, isSelected: currentModel?.isFemale ?? false)
        customGender(genderButton: maleButton, isSelected: !(currentModel?.isFemale ?? false))
        
    }
    
    private func customView() {
        self.navigationController?.navigationBar.backgroundColor = UIColor.appDarkYellow()
        self.title = Strings.add
        
        customAvatar(avatar: nameAvatar)
        customAvatar(avatar: birthdayAvatar)
        customAvatar(avatar: genderAvatar)
        customAvatar(avatar: profileAvatar)
        
        customContainer(containerView: nameContainer)
        customContainer(containerView: birthdayContainer)
        customContainer(containerView: genderContainer)
        customContainer(containerView: profileContainer)
        
        customLabel(label: nameLabel, text: Strings.name)
        customLabel(label: birthdayLabel, text: Strings.birthday)
        customLabel(label: genderLabel, text: Strings.gender)
        customLabel(label: profileLabel, text: Strings.profileImage)
        customLabel(label: profileLabel, text: Strings.profileImage)
        customLabel(label: maleLabel, text: Strings.male)
        customLabel(label: femaleLabel, text: Strings.female)
        
        profileButton.titleLabel?.font = UIFont.appFont(size: 14.0)
        profileButton.setTitle(Strings.changeImage, for: .normal)
        profileButton.addTarget(self, action: #selector(showChangeImageAlert), for: .touchUpInside)
        
        customGender(genderButton: femaleButton, isSelected: false)
        femaleButton.addTarget(self, action: #selector(femaleClicked), for: .touchUpInside)
        
        customGender(genderButton: maleButton, isSelected: false)
        maleButton.addTarget(self, action: #selector(maleClicked), for: .touchUpInside)
        
        leftButton.titleLabel?.font = UIFont.appFont(size: 16.0)
        leftButton.setTitle(Strings.save, for: .normal)
        leftButton.setTitleColor(UIColor.appDarkPink(), for: .normal)
        leftButton.layer.cornerRadius = 5.0
        leftButton.layer.masksToBounds = true
        leftButton.layer.borderWidth = 1.5
        leftButton.layer.borderColor = UIColor.appDarkPink().cgColor
        leftButton.backgroundColor = .clear
        leftButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        
        rightButton.titleLabel?.font = UIFont.appFont(size: 16.0)
        rightButton.setTitle(Strings.clearForm, for: .normal)
        rightButton.setTitleColor(UIColor.gray, for: .normal)
        rightButton.layer.cornerRadius = 5.0
        rightButton.layer.masksToBounds = true
        rightButton.layer.borderWidth = 1.5
        rightButton.layer.borderColor = UIColor.gray.cgColor
        rightButton.backgroundColor = .clear
        rightButton.addTarget(self, action: #selector(clearForm), for: .touchUpInside)

        profileImageView.layer.cornerRadius = 8.0
        profileImageView.layer.masksToBounds = true
        
        nameTextField.font = UIFont.appFont(size: 14.0)
        nameTextField.placeholder = Strings.enterName
        makeCloseToolbar(textField: nameTextField)
        
        birthdayTextField.font = UIFont.appFont(size: 14.0)
        birthdayTextField.placeholder = Strings.enterBirthday
        makeCloseToolbar(textField: birthdayTextField)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.calendar = Calendar(identifier: .persian)
        datePicker.locale = Locale(identifier: "fa_IR")
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.addTarget(self,
                             action: #selector(datePickerValueChanged(datePicker:)),
                             for: .valueChanged)
        birthdayTextField.inputView = datePicker
        
    }
    
    private func customAvatar(avatar: UIView) {
        avatar.layer.cornerRadius = avatar.frame.width/2
        avatar.layer.masksToBounds = true
        avatar.layer.borderWidth = 1.0
        avatar.layer.borderColor = UIColor.appDarkPink().cgColor
        avatar.backgroundColor = .clear
    }
    
    private func customContainer(containerView: UIView) {
        containerView.layer.cornerRadius = 8.0
        containerView.layer.masksToBounds = true
        containerView.backgroundColor = UIColor.appLightPink()
    }
    
    private func customLabel(label: UILabel, text: String) {
        label.font = UIFont.appFont(size: 14.0)
        label.text = "\(text):"
        label.textColor = .darkGray
    }
    
    private func customGender(genderButton: UIButton, isSelected: Bool) {
        genderButton.layer.cornerRadius = genderButton.frame.width/2
        genderButton.layer.masksToBounds = true
        genderButton.layer.borderWidth = 2.0
        genderButton.layer.borderColor = UIColor.appDarkPink().cgColor
        genderButton.backgroundColor = isSelected ? UIColor.appDarkYellow() : .clear
    }
    
    private func makeCloseToolbar(textField : UITextField) {
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

    @objc func closeVC() {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }

    @objc func close() {
        self.view.endEditing(true)
    }
    
    @objc func datePickerValueChanged(datePicker: UIDatePicker) {
        self.currentModel?.birthday = datePicker.date
        self.birthdayTextField.text = self.currentModel?.convertDateToString()
    }
    
    @objc func save() {
        self.view.endEditing(true)

        if (nameTextField.text?.isEmpty ?? true) || nameTextField.text == nil {
            Utils.showError(message: Strings.enterName)
            return
            
        } else if (birthdayTextField.text?.isEmpty ?? true) || birthdayTextField.text == nil {
            Utils.showError(message: Strings.enterBirthday)
            return
        }
        
        self.currentModel?.name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if self.currentModel?.avatarImageName != nil && self.currentModel?.avatarImageName != ""{
            _ = BirthdayManager.saveImage(
                image: (self.currentModel?.avatarImage)!,
                name: self.currentModel?.avatarImageName ?? "")
        }
        
        if isEditMode {
            BirthdayManager.updateBirthday(birthday: self.currentModel ?? BirthdayModel())
            self.closeVC()
            
        } else {
            BirthdayManager.addBirthdayToList(birthday: self.currentModel ?? BirthdayModel())
            Utils().showSuccess(message: Strings.successAlert)
            clearForm()

        }
    }

    @objc func clearForm() {
        self.view.endEditing(true)
        
        currentModel = BirthdayModel()
        
        nameTextField.text = currentModel?.name
        birthdayTextField.text = currentModel?.convertDateToString()
        profileImageView.image = currentModel?.avatarImage

        customGender(genderButton: femaleButton, isSelected: currentModel?.isFemale ?? false)
        customGender(genderButton: maleButton, isSelected: !(currentModel?.isFemale ?? false))
    }

    @objc func femaleClicked() {
        self.view.endEditing(true)
        
        currentModel?.isFemale = true
        
        customGender(genderButton: femaleButton, isSelected: true)
        customGender(genderButton: maleButton, isSelected: false)
        
        profileAvatar.image = UIImage(named: "Female")
        
        if currentModel?.avatarImageName == nil ||
            (currentModel?.avatarImageName?.isEmpty ?? true) {
            
            profileImageView.image = UIImage(named: "Female")
        }
    }
    
    @objc func maleClicked() {
        self.view.endEditing(true)
        
        currentModel?.isFemale = false
        
        customGender(genderButton: femaleButton, isSelected: false)
        customGender(genderButton: maleButton, isSelected: true)
        
        profileAvatar.image = UIImage(named: "Male")
        
        if currentModel?.avatarImageName == nil ||
            (currentModel?.avatarImageName?.isEmpty ?? true) {
            
            profileImageView.image = UIImage(named: "Male")
        }
    }
    
    @objc func showChangeImageAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: Strings.selectFromGallery, style: .default, handler: { action in
            
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .savedPhotosAlbum
                self.imagePicker.allowsEditing = true
                
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            
        }
        ))
        
        alert.addAction(UIAlertAction(title: Strings.takePicture, style: .default, handler: { action in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .camera
                self.imagePicker.allowsEditing = true
                
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        ))
        
        if currentModel?.avatarImageName != nil &&
            !(currentModel?.avatarImageName?.isEmpty ?? true) {
            
            alert.addAction(UIAlertAction(title: Strings.removeCurrentImage, style: .destructive, handler: { action in
                self.currentModel?.avatarImageName = nil
                self.currentModel?.avatarImage = self.currentModel?.getAvatar()
                self.profileImageView.image = self.currentModel?.avatarImage
            }
            ))
        }
        
        alert.addAction(UIAlertAction(title: Strings.cancel, style: .default, handler: { action in
        }
        ))
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
}


extension AddVC: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let name = UUID().uuidString
        
        self.currentModel?.avatarImage = image
        self.currentModel?.avatarImageName = name
        profileImageView.image = currentModel?.avatarImage
    }
    
}
