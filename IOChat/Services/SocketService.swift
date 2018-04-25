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
    // Singleton Class
    static let instance = SocketService()
    // Socket Manager
    let manager = SocketManager(socketURL: URL(string:BASE_URL)!)

    var socket:SocketIOClient!

    override init() {
        super.init()
    }
    
    // Started hte connection with the server
    func establishConnection(){
        socket = manager.defaultSocket
        socket.connect()
    }
    
    // Closes the connection with the server
    func closeConnection(){
        socket.disconnect()
    }
    
    // Adds a channel to the server
    func addChannel(channelName: String, channerDescription: String, completion: @escaping CompletionHandler){
        socket.emit("newChannel", channelName,channerDescription)
        completion(true)
    }
    
    // Fetches the new channel created form the server
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
    
    // Adds a message to the server
    func addMessage(messageBody: String, userID: String, channelId: String, completion: @escaping CompletionHandler){
        let user = UserDataService.instance
        socket.emit("newMessage", messageBody, userID, channelId, user.name, user.avatarName)
        completion(true)
    }
    
    // Fetches the new messages from the serves
    func getChatMessage(completion: @escaping (_ newMessage: Message) -> Void ){
        socket.on("messageCreated") { (dataArray, ack) in
            guard let msgBody = dataArray[0] as? String else {return}
            guard let channelId = dataArray[2] as? String else {return}
            guard let userName = dataArray[3] as? String else {return}
            guard let userAvatar = dataArray[4] as? String else {return}
            guard let messageId = dataArray[6] as? String else {return}
            guard let timeStamp = dataArray[7] as? String else {return}

            let newMessage = Message(message: msgBody, userName: userName, channelId: channelId, userAvatar: userAvatar, id: messageId, timeStamp: timeStamp)
            
            completion(newMessage)
        }
    }
}

