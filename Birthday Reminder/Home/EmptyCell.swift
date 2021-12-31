//
//  EmptyCell.swift
//  Birthday Reminder
//
//  Created by Zeinab Khosravinia on 5/4/1400 AP.
//

import UIKit

class EmptyCell: UITableViewCell {
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var containerView: UIView!

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
        
        emptyLabel.textColor = .darkGray
        emptyLabel.font = UIFont.appFont(size: 16.0)
        emptyLabel.text = Strings.noBirthday
    }

}
