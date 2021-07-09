//
//  ViewController.swift
//  knila project
//
//  Created by Fuzionest on 08/07/21.
//

import UIKit
import CoreData

class ViewController: UIViewController {
   
    @IBOutlet weak var userListTableview: UITableView!
    var userImageView = UIImageView()
    var usersListData = [Data]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Users"
        //Register tableview Xib
        userListTableview.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserTableViewCell")
        userListTableview.tableFooterView = UIView()
        getUserList()
    }
    
    func getUserList() {
        APIDownload.shared.downloadDataFromURL("https://reqres.in/api/", "users", "GET", [:]) { (data) in
            self.usersListData = data.data ?? []
            self.userListTableview.reloadData()
        }
    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userDetailCell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as? UserTableViewCell
        userDetailCell?.userName.text = "\(usersListData[indexPath.row].first_name ?? "") \( usersListData[indexPath.row].last_name ?? "")"
        userDetailCell?.userEmail.text = usersListData[indexPath.row].email ?? ""
        userDetailCell?.userImage.loadImage(usersListData[indexPath.row].avatar ?? "")
        userDetailCell?.selectionStyle = .none
        return userDetailCell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserDetailsViewController") as? UserDetailsViewController {
            if let navigator = navigationController {
                detailVc.delegate = self
                detailVc.userData = usersListData[indexPath.row]
                navigator.pushViewController(detailVc, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            if let detailVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserDetailsViewController") as? UserDetailsViewController {
                if let navigator = self.navigationController {
                    detailVc.delegate = self
                    detailVc.isEditUser = true
                    detailVc.userData = self.usersListData[indexPath.row]
                    navigator.pushViewController(detailVc, animated: true)
                }
            }

        })
        editAction.backgroundColor = UIColor.blue

        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            self.usersListData.remove(at: indexPath.row)
            self.userListTableview.reloadData()
        })
        deleteAction.backgroundColor = UIColor.red
        
        let addAction = UITableViewRowAction(style: .default, title: "Add", handler: { (action, indexPath) in
            
            if let detailVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserDetailsViewController") as? UserDetailsViewController {
                if let navigator = self.navigationController {
                    detailVc.delegate = self
                    detailVc.isAddUser = true
                    detailVc.userData = self.usersListData[indexPath.row]
                    navigator.pushViewController(detailVc, animated: true)
                }
            }
        })
        addAction.backgroundColor = .brown
        return [addAction, editAction, deleteAction]
    }}

extension ViewController: NewUserDelegate {
    func newUser(type: Data) {
        usersListData.append(type)
        userListTableview.reloadData()
    }
}
