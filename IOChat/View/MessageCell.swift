//
//  MessageCell.swift
//  IOChat
//
//  Created by Pritesh Patel on 23/04/18.
//  Copyright © 2018 COMP47390-41550. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(message: Message){
        messageLabel.text = message.message
        userNameLabel.text = message .userName
        userImg.image = UIImage(named: message.userAvatar)
        timestampLabel.text = message.timeStamp
    }

}
