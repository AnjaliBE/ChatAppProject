//
//  ViewController.swift
//  ChatApp
//
//  Created by Mac on 9/10/22.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var chatTableView: UITableView!
    var chats = [ChatList]()
    var chatListArray = [ChatList]()
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Chats"
        tableViewSetup()
        getChatList()
    }

    @IBAction func bookMarkAction(_ sender: Any) {
        if let databaseVC = storyboard?.instantiateViewController(identifier: "DatabaseVC") as? DatabaseVC {
            let dbhelperObj = DBHelper()
            dbhelperObj.createChatTable()
            self.chats = dbhelperObj.displayChats() ?? []
            databaseVC.chats = chats
            navigationController?.pushViewController(databaseVC, animated: true)
        }
         }
    @objc func clickButton(){
    if let databaseVC = storyboard?.instantiateViewController(identifier: "DatabaseVC") as? DatabaseVC {
        let dbhelperObj = DBHelper()
        dbhelperObj.createChatTable()
        self.chats = dbhelperObj.displayChats() ?? []
        databaseVC.chats = chats
        navigationController?.pushViewController(databaseVC, animated: true)
    }
     }
    func tableViewSetup(){
        
        chatTableView.dataSource = self
        chatTableView.delegate = self
        chatTableView.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatTableViewCell")
    }
    
    @objc func selectImage(gesture:UITapGestureRecognizer){
        imagePermission()
    }
    //MARK:- Permission Manager
    func imagePermission(){
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera not available", style: .default, handler: {(handler)in
           // self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: {(handler)in
            self.openGallery()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(handler)in }))
        self.present(alert, animated: true, completion: nil)
    }
    //MARK:- Camera Permission
   /* func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .camera
            imagePicker.mediaTypes = [kCIAttributeTypeImage as String]
            self.present(imagePicker, animated: true, completion: nil)
        }
    }*/
    //MARK:- Gallery Permission
    func openGallery(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let img = info[.originalImage]as? UIImage{
            let cell = chatTableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! ChatTableViewCell
            cell.profileImage.image = img
        }
    }
}
//MARK:Tableview Datasoure Method
extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = chatTableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath)as? ChatTableViewCell else{
            return UITableViewCell()
        }
        cell.nameLabel.text = chatListArray[indexPath.row].name
        cell.emailLabel.text = chatListArray[indexPath.row].email
        let status = chatListArray[indexPath.row].status
        if status == "active"{
            cell.statusImage.backgroundColor = .green
        }else{
            cell.statusImage.backgroundColor = .gray
        }
        
        //Tap Gesture Methods
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.selectImage(gesture:)))
        tapGesture.numberOfTapsRequired = 1
        cell.profileImage.isUserInteractionEnabled = true
        cell.profileImage.addGestureRecognizer(tapGesture)
        return cell
    }
}
//Mark:Tableview Delegate Method
extension ViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chat = chatListArray[indexPath.row]
        if let updataVC = storyboard?.instantiateViewController(identifier: "UpdateDataViewController") as? UpdateDataViewController {
            updataVC.chatData = chat
            updataVC.buttonTitle = "Save"
            navigationController?.pushViewController(updataVC, animated: true)
        }
    }
}
//MARK:- Method for fetch and bind data
extension ViewController{
    func getChatList(){
        Service.shareInstance.getChatListData{ response in
            DispatchQueue.main.async(execute:{
                if response?.status == "sucess"{
                    for i in(response?.data as?[ChatList])!{
                        self.chatListArray.append(i)
                    }
                    self.chatTableView.reloadData()
                }
            })
        }
    }
}
