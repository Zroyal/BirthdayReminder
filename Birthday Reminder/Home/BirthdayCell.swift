//
//  BirthdayCell.swift
//  Birthday Reminder
//
//  Created by Zeinab Khosravinia on 5/5/1400 AP.
//

import UIKit

class BirthdayCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var remaningDayCountLabel: UILabel!
    @IBOutlet weak var remaningDayLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configCell() {
        selectionStyle = .none
        
        containerView.layer.cornerRadius = 8.0
        containerView.layer.masksToBounds = true
        containerView.backgroundColor = UIColor.appLightPink()
        
        nameLabel.textColor = .black
        nameLabel.font = UIFont.appFont(size: 18.0)
        nameLabel.text = ""
        
        birthdayLabel.textColor = .darkGray
        birthdayLabel.font = UIFont.appFont(size: 14.0)
        birthdayLabel.text = ""
        
        remaningDayCountLabel.textColor = UIColor.appDarkPink()
        remaningDayCountLabel.font = UIFont.appFont(size: 18.0)
        remaningDayCountLabel.text = ""

        remaningDayLabel.textColor = UIColor.appDarkPink()
        remaningDayLabel.font = UIFont.appFont(size: 12.0)
        remaningDayLabel.text = Strings.remaningDay
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width/2
        avatarImageView.layer.masksToBounds = true

    }


}
