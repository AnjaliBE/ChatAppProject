//
//  ChatListModelClass.swift
//  ChatApp
//
//  Created by Mac on 9/10/22.
//

import Foundation

class ChatList:NSObject{
    var id:Int?
    var name:String?
    var email:String?
    var gender:String?
    var status:String?
    
    init(id:Int?,name:String?,email:String?,gender:String?,status:String?) {
        
        self.id = id
        self.name = name
        self.email = email
        self.gender = gender
        self.status = status
    }
}
