//
//  Service.swift
//  ChatApp
//
//  Created by Mac on 9/10/22.
//

import Foundation

class Service:NSObject {
      
    typealias CompletionBlock = (_ response:Response?)->Void
    static let shareInstance = Service()
    
    func getChatListData(completion:@escaping CompletionBlock){
        
        let urlString = "https://gorest.co.in/public/v2/users"
        guard let url = URL(string: urlString)else{ return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with:request){(data,response,error)in
        
            //Check if there is an error from response
            if error != nil {
               
                let response = Response(status: "sucess", message: "Could not load Data!", andResponseObject: nil)
                completion(response)
                return
                
            } else {
                
                if let responseData = data {
                    
                    do{
                        
                        let responseJSON = try JSONSerialization.jsonObject(with: responseData, options: [])as? [[String:AnyObject]]
                        
                        if let responseJSON = responseJSON{
                            
                            var chatData = Array<ChatList>()
                            
                            for dic in responseJSON{
                                let id = dic["id"]as?Int ?? 0
                                let name = dic["name"]as?String ?? ""
                                let email = dic["email"]as?String ?? ""
                                let gender = dic["gender"]as?String ?? ""
                                let status = dic["status"]as?String ?? ""
                                
                                let data = ChatList(id: id, name: name, email: email, gender: gender, status: status)
                                
                                chatData.append(data)
                            }
                               let response = Response(status: "sucess", message: "Sucess", andResponseObject: (chatData as? AnyObject?)!)
                            completion(response)
                            
                }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        dataTask.resume()
    }
}
