//
//  Response.swift
//  ChatApp
//
//  Created by Mac on 9/10/22.
//

import Foundation
class Response{
    //MARK:-Variables
    var message:String?
    var data:AnyObject?
    var status: String?
    
    //MARK:-Initializers
    init(status:String?,message:String?,andResponseObject data:AnyObject?) {
        self.status = status
        self.message = status
        self.data = data
    }
}
