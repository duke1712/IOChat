//
//  AuthService.swift
//  IOChat
//
//  Created by Pritesh Patel on 21/04/18.
//  Copyright © 2018 COMP47390-41550. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AuthService{
    // Singleton instance
    static let instance = AuthService()
    
    // UserDefaults to store the auth details
    let defaults = UserDefaults.standard
    
    
    // States whether user is logged in or not
    var isLoggedIn:Bool{
        get{
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set{
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    // Stores the auth token of the user for requesting apis
    var authToken:String{
        get{
            return defaults.value(forKey: TOKEN_KEY) as! String
        }
        set{
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    
    // Email of the user
    var userEmail:String{
        get{
            return defaults.value(forKey: USER_EMAIL) as! String
        }
        set{
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    // Function to register the user using the account/register api
    func registerUser(email: String, password: String, completion: @escaping CompletionHandler){
        let lowerCaseEmail = email.lowercased()
        
        let body:[String: Any] = ["email":lowerCaseEmail,
                                  "password":password
        ]
        
        // Using Alamofire to execute the request
        Alamofire.request(URL_REGISTER,method: .post,parameters: body,encoding: JSONEncoding.default, headers: HEADER).responseString { (response) in
            if response.result.error == nil{
                if (response.result.value?.contains("message"))!{
                    completion(false)
                }else{
                completion(true)
                }
            }else{
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    // Function to login the user using the account/login api
    func loginUser(email: String, password: String, completion: @escaping CompletionHandler){
        let lowerCaseEmail = email.lowercased()
        
        let body:[String: Any] = ["email":lowerCaseEmail,
                                  "password":password
        ]
        // Using Alamofire to execute the request

        Alamofire.request(URL_LOGIN,method: .post,parameters: body,encoding: JSONEncoding.default, headers: HEADER).responseJSON(completionHandler: { (response) in
            if response.result.error == nil{
                
                guard let data = response.data else {return}
                let json = JSON(data)
                // Checking whether the credentials are correct
                if json["message"].stringValue == ""{
                self.userEmail = json["user"].stringValue
                self.authToken = json["token"].stringValue
                self.isLoggedIn=true
                completion(true)
                }
                else{
                    self.isLoggedIn=false
                    completion(false)
                }
            }
            else{
                completion(false)
                debugPrint(response.result.error as Any)
            }
                
        })
    }
    
    // Function to add the user using the user/add api
    func createUser(name: String, email: String, avatarName: String, completion: @escaping CompletionHandler){
        let lowerCaseEmail = email.lowercased()
        
        let body:[String: Any] = ["email":lowerCaseEmail,
                                  "avatarName":avatarName,
                                  "name":name
        ]
        // Using Alamofire to execute teh request
        Alamofire.request(URL_USER_ADD, method: .post, parameters: body, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil{
                guard let data = response.data else {return}
                self.setUserInfo(data: data)
                completion(true)
            }
            else{
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    // Fetching user details by email
    func findUserByEmail(completion: @escaping CompletionHandler){
        // Using Alamofire to execute teh request
        Alamofire.request("\(URL_USER_BY_EMAIL)\(userEmail)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil{
                guard let data = response.data else {return}
                self.setUserInfo(data: data)
                completion(true)
            }
            else{
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    // Adding user data to UserDataService instance
    func setUserInfo(data: Data){
        let json = JSON(data)
        let id = json["_id"].stringValue
        let avatarName = json["avatarName"].stringValue
        let email = json["email"].stringValue
        let name = json["name"].stringValue
        UserDataService.instance.setUserData(id: id, avatar: avatarName, email: email, name: name)
    }
}
