//
//  ChannelCell.swift
//  IOChat
//
//  Created by Pritesh Patel on 23/04/18.
//  Copyright © 2018 COMP47390-41550. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell {

    @IBOutlet weak var channelLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected{
            self.layer.backgroundColor = UIColor(white: 1, alpha: 0.2).cgColor
        }
        else
        {
            self.layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    func configureCell(channel: Channel){
        let title = channel.channelTitle ?? ""
        channelLabel.text = "#\(title)"
        channelLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        
        // If the channel has unread messages it changes the fontsize and type
        for id in MessageService.instance.unreadChannels{
            if(id == channel.id){
                channelLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
            }
        }
    }

}
