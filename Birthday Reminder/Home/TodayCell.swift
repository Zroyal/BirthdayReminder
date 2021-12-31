//
//  TodayCell.swift
//  Birthday Reminder
//
//  Created by Zeinab Khosravinia on 5/5/1400 AP.
//

import UIKit

class TodayCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var congrateButton: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCell() {
        selectionStyle = .none

        avatarImageView.layer.cornerRadius = avatarImageView.frame.width/2
        avatarImageView.layer.masksToBounds = true
        
        containerView.layer.cornerRadius = 8.0
        containerView.layer.masksToBounds = true
        containerView.backgroundColor = UIColor.appLightPink()

        congrateButton.layer.cornerRadius = 8.0
        congrateButton.layer.masksToBounds = true
        congrateButton.backgroundColor = UIColor.appDarkPink()
        congrateButton.setTitle(Strings.sayCongrate, for: .normal)
        congrateButton.titleLabel?.font = UIFont.appFont(size: 14.0)
        
        nameLabel.textColor = .black
        nameLabel.font = UIFont.appFont(size: 16.0)
        nameLabel.text = ""
    }

}
