//
//  HeaderCell.swift
//  Birthday Reminder
//
//  Created by Zeinab Khosravinia on 5/4/1400 AP.
//

import UIKit

class HeaderCell: UITableViewCell {
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var iconContainer: UIView!
    @IBOutlet weak var iconImageView: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func configCell(isToday: Bool) {
        selectionStyle = .none
        
        topLabel.textColor = .black
        topLabel.font = UIFont.appFont(size: 18.0)
        
        bottomLabel.textColor = .darkGray
        bottomLabel.font = UIFont.appFont(size: 12.0)
        
        iconContainer.layer.cornerRadius = iconContainer.frame.width/2
        iconContainer.layer.masksToBounds = true
        iconContainer.layer.borderWidth = 1.0
        iconContainer.layer.borderColor = UIColor.appDarkPink().cgColor
        iconContainer.backgroundColor = .clear
        
        if isToday {
            topLabel.text = Strings.todayBirthdays
            bottomLabel.text = Strings.todayBirthdaysComment
            iconImageView.image = UIImage(named: "Cake")
            
        } else {
            topLabel.text = Strings.birthdayList
            bottomLabel.text = Strings.birthdayListComment
            iconImageView.image = UIImage(named: "Calendar")
        }

    }
}
