//
//  ChatVC.swift
//  IOChat
//
//  Created by Pritesh Patel on 21/04/18.
//  Copyright © 2018 COMP47390-41550. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {

    @IBOutlet weak var menuButton: UIButton!
    
    
    @IBOutlet weak var channelNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_ :)), name: NOTIF_USER_DATA_CHANGE, object: nil)
        if AuthService.instance.isLoggedIn{
            AuthService.instance.findUserByEmail(completion: { (success) in
                NotificationCenter.default.post(name: NOTIF_USER_DATA_CHANGE, object: nil)
            })
        }
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTIF_CHANNELS_SELECTED, object: nil)
       
    }
    
    @objc func channelSelected(_ notif: Notification ){
        updateWithChannel()
    }
    
    func updateWithChannel(){
        let channelName = MessageService.instance.selectedChannel?.channelTitle ?? ""
        channelNameLabel.text = "#\(channelName)"
        getMessages()
    }
    @objc func userDataDidChange(_ notif: Notification){
        if AuthService.instance.isLoggedIn{
            // getChannels
            onLoginGetMessages()
        }
        else{
            channelNameLabel.text = "Please Login"
        }
    }
    
    func onLoginGetMessages(){
        MessageService.instance.findAllChannel { (success) in
            if success {
                if MessageService.instance.channels.count > 0{
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    self.updateWithChannel()
                }
                else{
                    self.channelNameLabel.text="No Channels Yet"
                }
            }
        }
    }
    func getMessages(){
        guard let channelId = MessageService.instance.selectedChannel?.id else {return}
        MessageService.instance.findAllMessagesForChannel(channelId: channelId) { (success) in
            
        }
    }
}
