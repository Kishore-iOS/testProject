//
//  UserDetailsViewController.swift
//  knila project
//
//  Created by Fuzionest on 08/07/21.
//

import UIKit
import CoreData

protocol NewUserDelegate {
    func newUser(type: Data)
}

class UserDetailsViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userId: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var imagePickerBtn: UIButton!
    var userData: Data?
    var delegate: NewUserDelegate?
    var userNames = [""]
    var isAddUser = false
    var isEditUser = false
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        retriveData()
    }
    
    func setupView() {
        navigationItem.title = isEditUser ? "Edit User" : "User Details"
        let addBtn = UIButton.init(type: UIButton.ButtonType.custom)
        addBtn.frame = CGRect(x: 0, y: 0, width: 50, height: 24)
        addBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        addBtn.setTitle("Add", for: .normal)
        addBtn.setTitleColor(UIColor.red, for: .normal)
        addBtn.layer.borderColor = UIColor.red.cgColor
        addBtn.layer.borderWidth = 1.0
        addBtn.layer.cornerRadius = 3.0
        addBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        addBtn.addTarget(self, action: #selector(userAddAction), for: .touchUpInside)
        let barButton:UIBarButtonItem! = UIBarButtonItem.init(customView: addBtn)
        self.navigationItem.rightBarButtonItem = barButton
        
        userImage.layer.cornerRadius = userImage.frame.size.height/2
        userImage.layer.borderWidth = 1
        userImage.clipsToBounds = true
        userImage.loadImage(userData?.avatar ?? "")
        userName.text = "User Name: \(userData?.first_name ?? "") \(userData?.last_name ?? "")"
        userId.text = "User Id: \(userData?.id ?? 0)"
        userEmail.text = "Email: \(userData?.email ?? "")"
        userName.isUserInteractionEnabled = false
        userEmail.isUserInteractionEnabled = false
        userId.isUserInteractionEnabled = false
        saveBtn.setTitleColor(.white, for: .normal)
        //saveBtn.addTarget(self, action: #selector(savedata), for: .touchUpInside)
        saveBtn.backgroundColor = .black
        if (isAddUser) {
            userAddAction()
        }else if (isEditUser) {
            userName.isUserInteractionEnabled = true
            userEmail.isUserInteractionEnabled = true
            userId.isUserInteractionEnabled = true
        }
    }
    
    @objc func userAddAction() {
        isAddUser = true
        navigationItem.title = "Add User"
        userName.isUserInteractionEnabled = true
        userEmail.isUserInteractionEnabled = true
        userId.isUserInteractionEnabled = true
        userName.text = ""
        userId.text = ""
        userEmail.text = ""
        userName.placeholder = "Enter Username"
        userId.placeholder = "Enter userid"
        userEmail.placeholder = "Enter email"
        userImage.image = UIImage()
        imagePickerBtn.isUserInteractionEnabled = true
        imagePickerBtn.addTarget(self, action: #selector(showImagePicker), for: .touchUpInside)
        saveBtn.setTitle("Add User", for: .normal)
    }
    
    //Store data to core data
    @objc func savedata() {
        if (userNames.contains("\(userData?.first_name ?? "") \(userData?.last_name ?? "")")) && !isAddUser {
            Extensions.showAlert("User Already Existed", self)
        }else {
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "UserList", in: context)
            let newUser = NSManagedObject(entity: entity!, insertInto: context)
            
            newUser.setValue(isAddUser ? userName.text : "\(userData?.first_name ?? "") \(userData?.last_name ?? "")", forKey: "userName")
            newUser.setValue(isAddUser ? userId.text : "\(userData?.id ?? 0)", forKey: "userId")
            newUser.setValue(isAddUser ? userName.text : "\(userData?.avatar ?? "")", forKey: "userImage")
            newUser.setValue(isAddUser ? userEmail.text : "\(userData?.email ?? "")", forKey: "email")
            do {
                try context.save()
                Extensions.showAlert("Data saved Successfully", self)
                userNames.append("\(userData?.first_name ?? "") \(userData?.last_name ?? "")")
                imagePickerBtn.isUserInteractionEnabled = false
                if isAddUser {
                    var user: Data!
                    user.email = userEmail.text ?? ""
                    user.id = Int(userId.text ?? "0") ?? 0
                    user.first_name = userName.text ?? ""
                    delegate?.newUser(type: user)
                    navigationController?.popViewController(animated: true)
                }
            } catch {
                print("Failed saving")
                Extensions.showAlert("Failed saving", self)
            }
        }
        
       
    }
    
    //Get data from coredata
    func retriveData() {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserList")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
               print(data.value(forKey: "userName") as! String)
                userNames.append(data.value(forKey: "userName") as! String)
            }
        } catch {
            print("Failed")
        }

    }
}
//MARK:- ImagePicker delegate
extension UserDetailsViewController: UIImagePickerControllerDelegate {
    @objc func showImagePicker()->Void
    {
        self.view.endEditing(true)
        // Creating the Action sheet
        let imagePickerController = UIAlertController.init(title:nil, message:nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let cameraAction = UIAlertAction.init(title:"Take Photo", style:UIAlertAction.Style.default) { (UIAlertAction) -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
            {
                
                let cameraPicker = UIImagePickerController.init()
                cameraPicker.sourceType = UIImagePickerController.SourceType.camera
                cameraPicker.cameraFlashMode = UIImagePickerController.CameraFlashMode.off
                cameraPicker.allowsEditing = false
                cameraPicker.delegate = self
                self.present(cameraPicker, animated:true, completion:nil)
            }
            else
            {
                Extensions.showAlert("This device doesn't have a camera.", self)
            }
        }
        
        let galleryAction = UIAlertAction.init(title:"Choose from Library", style:UIAlertAction.Style.default) { (UIAlertAction) -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary)
            {
                let galleryPicker = UIImagePickerController()
                galleryPicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                galleryPicker.allowsEditing = false
                galleryPicker.delegate = self
                galleryPicker.navigationBar.isTranslucent = false
                galleryPicker.navigationBar.tintColor = UIColor.black
                galleryPicker.navigationBar.barTintColor = UIColor.white
                self.present(galleryPicker, animated:true, completion:nil)
                
            }
            else
            {
                Extensions.showAlert("This device doesn't support photo libraries.", self)
            }
        }
        
        let cancelAction = UIAlertAction.init(title:"CANCEL", style:UIAlertAction.Style.destructive, handler:nil)
        imagePickerController.addAction(cameraAction)
        imagePickerController.addAction(galleryAction)
        imagePickerController.addAction(cancelAction)
        self.present(imagePickerController, animated:true, completion:nil)
    }
    /**
     This delegate method of the picker controller is calling when user select a photo from gallery or take a photo using camera.
     */
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        // Image Selected
        let selectedImage:UIImage = info["UIImagePickerControllerOriginalImage"] as! UIImage
        userImage.image = selectedImage
        self.view.bringSubviewToFront(userImage)
        picker.dismiss(animated: true, completion:nil)
        
    }
    /**
     This delegate method of the picker controller is called when user cancel the picker window
     */
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion:nil)
        
    }
}
