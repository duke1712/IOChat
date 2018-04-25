//
//  MessageService.swift
//  IOChat
//
//  Created by Pritesh Patel on 23/04/18.
//  Copyright © 2018 COMP47390-41550. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService{
    // Singleton Class
    static let instance = MessageService()
    
    // Stores the channels
    var channels = [Channel]()
    
    // Stored the messages of a channel
    var messages = [Message]()
    
    // stores the ids of the channels with unread messages
    var unreadChannels = [String]()
    
    //Channel which is currently selected
    var selectedChannel : Channel?
    
    // Fetch all the chanels from the server
    func findAllChannel(completion: @escaping CompletionHandler){
        
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON{ (response) in
            if response.result.error == nil{
                guard let data = response.data else {return}
                
                if let json = try? JSON(data: data).array{
                    for item in json!{
                        let name = item["name"].stringValue
                        let channelDesc = item["description"].stringValue
                        let id = item["_id"].stringValue

                        let channel = Channel(channelTitle: name, channelDesc: channelDesc, id: id)
                        self.channels.append(channel)
                    }
                    // Push a notification to indicate that the channels are loaded
                    NotificationCenter.default.post(name: NOTIF_CHANNELS_LOADED, object: nil)
                    
                    completion(true)
                }
            }else{
                debugPrint(response.result.error as Any)
                completion(false)
            }
        }
        
    }
    
    // Fetching all messages for a clanne;
    func findAllMessagesForChannel(channelId: String, completion: @escaping CompletionHandler){
        
        Alamofire.request("\(URL_GET_MESSAGES)\(channelId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                self.clearMessages()
                guard let data  = response.data else {return}
                // Parsing JSON
                if let json = try? JSON(data: data).array {
                    for item in json!{
                        let messageBody = item["messageBody"].stringValue
                        let channelId = item["channelId"].stringValue
                        let id = item["_id"].stringValue
                        let userName = item["userName"].stringValue
                        let userAvatar = item["userAvatar"].stringValue
                        let timeStamp = item["timeStamp"].stringValue
                        
                        let message  = Message(message: messageBody, userName: userName, channelId: channelId, userAvatar: userAvatar, id: id, timeStamp: timeStamp)
                        
                        self.messages.append(message)
                    }
                    completion(true)
                }
            }else{
                
            }
        }
    }
    
    
    func clearMessages(){
        messages.removeAll()
    }
    func clearChannels(){
        channels.removeAll()
    }
}
