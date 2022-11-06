//
//  UpdateDataViewController.swift
//  ChatApp
//
//  Created by Mac on 015/10/22.
//

import UIKit

protocol UpdateProtocol: AnyObject {
    func UpdateData(chatList:[ChatList])
}
class UpdateDataViewController: UIViewController {
    
    var buttonTitle: String?
    @IBOutlet weak var txtId: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtStatus: UITextField!
    @IBOutlet weak var updateBtn: UIButton!
    weak var delegate: UpdateProtocol?
    var chatData: ChatList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateBtn.setTitle(buttonTitle, for: .normal)
        txtId.text = String(chatData?.id ?? 12)
        txtName.text = chatData?.name
        txtEmail.text = chatData?.email
        txtGender.text = chatData?.gender
        txtStatus.text = chatData?.status
        
        navigationItem.title = "ChatData"
        
        updateBtn.layer.cornerRadius = 15
        updateBtn.layer.masksToBounds = true
        
    }
    //MARK:- Update data in Database
    @IBAction func updateButtonClick(_ sender: Any) {
        let dbhelperObj = DBHelper()
        dbhelperObj.createChatTable()
        let modelInfo = ChatList(id: Int(txtId.text!) , name: txtName.text, email: txtEmail.text, gender: txtGender.text, status: txtStatus.text)
        if buttonTitle == "Update" {
            dbhelperObj.updateUserProfile(userId: txtId.text ?? "", user: modelInfo)
            delegate?.UpdateData(chatList: dbhelperObj.displayChats() ?? [])
        } else {
        dbhelperObj.insertChat(chat: modelInfo)
    }
    
}
}
