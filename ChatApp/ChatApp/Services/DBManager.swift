//
//  DBManager.swift
//  ChatApp
//
//  Created by Mac on 016/10/22.
//
import Foundation
import SQLite3

class DBHelper {
    var db : OpaquePointer?
    init() {
        db = createAndOpen()
    }
    private func createAndOpen() -> OpaquePointer? {
        var db : OpaquePointer?
        do {
            let documentDir = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("Chat.sqlite")
            if sqlite3_open(documentDir.path, &db) == SQLITE_OK{
                print("open\(documentDir.path)")
                print("database create and open successfully...")
                return db
            }else{
                print("database allready exit")
                return db
            }
        }catch{
            print(error.localizedDescription)
        }
    return nil
    }
    
    func createChatTable(){
        var createStatement : OpaquePointer?
        let createTableQuery = "CREATE TABLE IF NOT EXISTS Chat(id TEXT PRIMARY KEY,name TEXT,gender TEXT,email TEXT,status TEXT)"
        if sqlite3_prepare_v2(db, createTableQuery, -1, &createStatement, nil) == SQLITE_OK{
            if sqlite3_step(createStatement) == SQLITE_DONE{
                print("User table create successfully...")
            }else{
                print("unable to create user table...")
            }
        }else{
            print("unable to prepare create atble statement")
        }
    }
    
    func insertChat(chat : ChatList){
        var insertStatement : OpaquePointer?
        let insertQuery = "INSERT INTO Chat(id,name,gender,email,status) VALUES(?,?,?,?,?)"
        if sqlite3_prepare_v2(db, insertQuery, -1, &insertStatement, nil) == SQLITE_OK{
            let idNS  = String(chat.id ?? 0) as! NSString
            let idText = idNS.utf8String
            sqlite3_bind_text(insertStatement, 2, idText, -1, nil)
            
            let nameNS  = chat.name as! NSString
            let nameText = nameNS.utf8String
            sqlite3_bind_text(insertStatement, 2, nameText, -1, nil)
            
            let genderNS  = chat.gender as! NSString
            let genderText = genderNS.utf8String
            sqlite3_bind_text(insertStatement, 3, genderText, -1, nil)
        
            let emailNS  = chat.email as! NSString
            let emailText = emailNS.utf8String
            sqlite3_bind_text(insertStatement, 4, emailText, -1, nil)
       
            let useridNS  = chat.status as! NSString
            let useridText = useridNS.utf8String
            sqlite3_bind_text(insertStatement, 5, useridText, -1, nil)
        
          if sqlite3_step(insertStatement) == SQLITE_DONE{
                print("user added succ.......")
          }else{
            print("unable to add")
          }
        }else{
            print("unable to prepare query!!!")
        }
        sqlite3_finalize(insertStatement)
    }
    
func displayChats() -> [ChatList]? {
        var selectStatement : OpaquePointer?
        let selectQuery = "SELECT * FROM Chat"
        var chats = [ChatList]()
        if sqlite3_prepare_v2(db, selectQuery, -1, &selectStatement, nil) == SQLITE_OK{
            while sqlite3_step(selectStatement) == SQLITE_ROW {

                guard  let userId_CStr = sqlite3_column_text(selectStatement, 0)else{
                    print("error while getting userId from db!")
                    continue
                }
                let id = String(cString: userId_CStr)
                
                guard let name_CStr = sqlite3_column_text(selectStatement, 1) else {
                    print("error while getting name from db!!")
                    continue
                }
                let name = String(cString: name_CStr)

                guard  let gender_CStr = sqlite3_column_text(selectStatement, 2)else{
                    print("error while getting gender from db!")
                    continue
                }
                let gender = String(cString: gender_CStr)

                guard  let email_CStr = sqlite3_column_text(selectStatement, 3)else{
                    print("error while getting gender from db!")
                    continue
                }
                let email = String(cString: email_CStr)

               guard  let status_CStr = sqlite3_column_text(selectStatement, 4)else{
                    print("error while getting password from db!")
                    continue
                }
                let status = String(cString: status_CStr)
                let user = ChatList(id: Int(id), name: name, email: email, gender: gender, status: status)
                chats.append(user)
            }
            sqlite3_finalize(selectStatement)
            return chats
        }else{
            print("unable to prepare statement")
        }
        return nil
    }
    
    func updateUserProfile(userId : String,user:ChatList){
        var updateStatement : OpaquePointer?
        //(name,gender,address,email,userId,password)
        let query = "UPDATE Chat SET id = ?, name = ?, gender = ?,email = ?,status = ? WHERE id = '\(userId)'"
        if sqlite3_prepare_v2(db, query, -1, &updateStatement, nil) == SQLITE_OK{
            let idNS  = String(user.id ?? 0) as! NSString
            let idText = idNS.utf8String
            sqlite3_bind_text(updateStatement, 1, idText, -1, nil)
            
            let nameNS  = user.name as! NSString
            let nameText = nameNS.utf8String
            sqlite3_bind_text(updateStatement, 2, nameText, -1, nil)
            
            let genderNS  = user.gender as! NSString
            let genderText = genderNS.utf8String
            sqlite3_bind_text(updateStatement, 3, genderText, -1, nil)
           
            
            let emailNS  = user.email as! NSString
            let emailText = emailNS.utf8String
            sqlite3_bind_text(updateStatement, 4, emailText, -1, nil)
       
            let statusNS  = user.status as! NSString
            let statusText = statusNS.utf8String
            sqlite3_bind_text(updateStatement, 5, statusText, -1, nil)
        
            if sqlite3_step(updateStatement) == SQLITE_DONE{
                sqlite3_finalize(updateStatement)
                  print("user updated succ.......")
            }else{
              print("unable to update")
            }
            
        }
    }
    
}
