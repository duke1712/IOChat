//
//  UserDataService.swift
//  IOChat
//
//  Created by Pritesh Patel on 22/04/18.
//  Copyright © 2018 COMP47390-41550. All rights reserved.
//

import Foundation
class UserDataService{
    static let instance=UserDataService()
    
    public private(set) var id = ""
    public private(set) var avatarName = ""
    public private(set) var email = ""
    public private(set) var name = ""
    
    func setUserData(id: String, avatar: String,email: String,name: String){
        self.id=id
        self.avatarName=avatar
        self.email=email
        self.name=name
    }
    
    func setAvatarName(avatarName:String){
        self.avatarName=avatarName
    }
    func logoutUser(){
        id=""
        avatarName=""
        email=""
        name=""
        AuthService.instance.isLoggedIn=false
        AuthService.instance.userEmail=""
        AuthService.instance.authToken=""
    }
}
