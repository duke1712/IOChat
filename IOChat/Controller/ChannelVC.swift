//
//  ChannelVC.swift
//  IOChat
//
//  Created by Pritesh Patel on 21/04/18.
//  Copyright © 2018 COMP47390-41550. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
       tableView.dataSource=self
        tableView.delegate = self
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60;
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange), name: NOTIF_USER_DATA_CHANGE, object: nil)
        
        SocketService.instance.getChanner { (success) in
            if success{
                self.tableView.reloadData()
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.channelsLoaded(_:)), name: NOTIF_CHANNELS_LOADED, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupUserInfo()
    }
    
    func setupUserInfo(){
        if AuthService.instance.isLoggedIn{
            loginButton.setTitle(UserDataService.instance.name, for: .normal)
            userImg.image = UIImage(named: UserDataService.instance.avatarName)
        }else{
            loginButton.setTitle("Login", for: .normal)
            userImg.image = UIImage(named: "menuProfileIcon")
            userImg.backgroundColor = UIColor.clear
            tableView.reloadData()
        }
    }
    @IBAction func addChannelPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn{
            let addChannel = AddChannelVC()
            addChannel.modalPresentationStyle = .custom
            present(addChannel, animated: true, completion: nil)
        }
        
    }
    
    @objc func userDataDidChange(_ notif: Notification){
        setupUserInfo()
    }
    
    @objc func channelsLoaded(_ notif : Notification){
        tableView.reloadData()
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if AuthService.instance.isLoggedIn{
            let profile = ProfileVC()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
        }else{
            performSegue(withIdentifier: TO_LOGIN, sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as? ChannelCell{
        let channel = MessageService.instance.channels[indexPath.row]
        cell.configureCell(channel: channel)
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.channels.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = MessageService.instance.channels[indexPath.row]
        MessageService.instance.selectedChannel = channel
        NotificationCenter.default.post(name: NOTIF_CHANNELS_SELECTED, object: nil)
        
        self.revealViewController().revealToggle(animated: true)
    }
}
