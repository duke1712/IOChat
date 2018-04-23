//
//  SocketService.swift
//  IOChat
//
//  Created by Pritesh Patel on 23/04/18.
//  Copyright © 2018 COMP47390-41550. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {
    static let instance = SocketService()
    let manager = SocketManager(socketURL: URL(string:BASE_URL)!)

    var socket:SocketIOClient!

    override init() {
        super.init()
    }
    
    func establishConnection(){
        socket = manager.defaultSocket
        socket.connect()
    }
    
    func closeConnection(){
        socket.disconnect()
    }
    func addChannel(channelName: String, channerDescription: String, completion: @escaping CompletionHandler){
        socket.emit("newChannel", channelName,channerDescription)
        completion(true)
    }
    
    func getChannel(completion: @escaping CompletionHandler){
        socket.on("channelCreated") { (dataArray, ack) in
            guard let channelName = dataArray[0] as? String else {return}
            guard let channelDesc = dataArray[1] as? String else {return}
            guard let channelId = dataArray[2] as? String else {return}
            
            let newChannel = Channel(channelTitle: channelName, channelDesc: channelDesc, id: channelId)
            MessageService.instance.channels.append(newChannel)
            completion(true)
        }
    }
    
    func addMessage(messageBody: String, userID: String, channelId: String, completion: @escaping CompletionHandler){
        let user = UserDataService.instance
        socket.emit("newMessage", messageBody, userID, channelId, user.name, user.avatarName)
        completion(true)
    }
}

