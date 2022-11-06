//
//  DatabaseVC.swift
//  ChatApp
//
//  Created by Mac on 015/10/22.
//

import UIKit

class DatabaseVC: UIViewController {
    @IBOutlet weak var chatDbTableview: UITableView!
    var chats = [ChatList]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()
    }
    func tableViewSetup(){
        chatDbTableview.delegate = self
        chatDbTableview.dataSource = self
        chatDbTableview.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatTableViewCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        let dbhelperObj = DBHelper()
        dbhelperObj.createChatTable()
        self.chats = dbhelperObj.displayChats() ?? []
      //  databaseVC.chats = chats
    }
}

extension DatabaseVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = chatDbTableview.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath)as? ChatTableViewCell else{
            return UITableViewCell()
        }
        cell.nameLabel.text = chats[indexPath.row].name
        cell.emailLabel.text = chats[indexPath.row].email
        let status = chats[indexPath.row].status
        if status == "active"{
            cell.statusImage.backgroundColor = .green
        }else{
            cell.statusImage.backgroundColor = .gray
        }
        
        //Tap Gesture Methods
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.selectImage(gesture:)))
//        tapGesture.numberOfTapsRequired = 1
//        cell.profileImage.isUserInteractionEnabled = true
//        cell.profileImage.addGestureRecognizer(tapGesture)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chat = chats[indexPath.row]
        if let updataVC = storyboard?.instantiateViewController(identifier: "UpdateDataViewController") as? UpdateDataViewController {
            updataVC.chatData = chat
            updataVC.delegate = self
            updataVC.buttonTitle = "Update"
            navigationController?.pushViewController(updataVC, animated: true)
        }
    }
}
extension DatabaseVC: UpdateProtocol {
    func UpdateData(chatList: [ChatList]) {
        self.chats = chatList
        chatDbTableview.reloadData()
    }
}
