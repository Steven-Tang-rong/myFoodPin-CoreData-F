//
//  NewRestaurantController.swift
//  FoodPin
//
//  Created by TANG,QI-RONG on 2020/6/1.
//  Copyright © 2020 Steven. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

class NewRestaurantController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var NewRestaurant: RestaurantMO!
    
    @IBOutlet var nameTextField: RoundedTextField!{
        didSet{
            nameTextField.tag = 1
            nameTextField.becomeFirstResponder()
            nameTextField.delegate = self
        }
    }
    
    @IBOutlet var typeTextField: RoundedTextField! {
        didSet{
            typeTextField.tag = 2
            typeTextField.delegate = self
        }
    }
    
    @IBOutlet var addressTextField: RoundedTextField! {
        didSet{
            addressTextField.tag = 3
            addressTextField.delegate = self
        }
    }
    
    @IBOutlet var phoneTextField: RoundedTextField! {
        didSet{
            phoneTextField.tag = 4
            phoneTextField.delegate = self
        }
    }
    
    @IBOutlet var descriptionTextView: UITextView! {
        didSet {
            descriptionTextView.tag = 5
            descriptionTextView.layer.cornerRadius = 5.0
            descriptionTextView.layer.masksToBounds = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = view.viewWithTag(textField.tag + 1) {
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //設定導覽列外觀
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.4934554561, blue: 0.5243053216, alpha: 1)
        //navigationController?.navigationBar.shadowImage = UIImage()
        
        if let customFont = UIFont(name: "Snell Roundhand", size: 35.0) {
            navigationController?.navigationBar.largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor(red: 231, green: 76, blue: 60), NSAttributedString.Key.font: customFont
                ]
        }
    }
    
    //MARK: - 呈現照片庫
    override func  tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            
            let photoSourceRequestController = UIAlertController(title: "", message: "選擇圖片", preferredStyle: .actionSheet)
            
            let cameraAction = UIAlertAction(title: "開啟相機", style: .default, handler: { (action) in
                
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .camera
                    imagePicker.delegate = self
                    
                    self.present(imagePicker, animated: true, completion: nil)
                }
                
            })
            
            let photoLibraryAction = UIAlertAction(title: "開啟相簿", style: .default, handler: { (action) in
                
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .photoLibrary
                    imagePicker.delegate = self
                    
                    self.present(imagePicker, animated: true, completion: nil)
                }
            })
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: .none)
            
            photoSourceRequestController.addAction(cameraAction)
            photoSourceRequestController.addAction(photoLibraryAction)
            photoSourceRequestController.addAction(cancelAction)
            
            //for iPad
            
            if let popoverController = photoSourceRequestController.popoverPresentationController{
                
                if let cell = tableView.cellForRow(at: indexPath){
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }
            
            present(photoSourceRequestController, animated: true, completion: nil)
        }
    }
    



// MARK: - UIImagePickerControllerDelegate methods & 使用Code約束條件

  @IBOutlet var photoImageView: UIImageView!

func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
        photoImageView.image = selectedImage
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
    }
    
    //左
    let leadingConstraint = NSLayoutConstraint(item: photoImageView as Any, attribute: .leading, relatedBy: .equal, toItem: photoImageView.superview, attribute: .leading, multiplier: 1, constant: 0)

    leadingConstraint.isActive = true
    
    //右
    let trailingConstraint = NSLayoutConstraint(item: photoImageView as Any, attribute: .trailing, relatedBy: .equal, toItem: photoImageView.superview, attribute: .trailing, multiplier: 1, constant: 0)
    
    trailingConstraint.isActive = true
    
    //上
    let topConstraint = NSLayoutConstraint(item: photoImageView as Any, attribute: .top, relatedBy: .equal, toItem: photoImageView.superview, attribute: .top, multiplier: 1, constant: 0)
    
    topConstraint.isActive = true
    
    //下
    let bottomConstraint = NSLayoutConstraint(item: photoImageView as Any, attribute: .bottom, relatedBy: .equal, toItem: photoImageView.superview, attribute: .bottom, multiplier: 1, constant: 0)
    
    bottomConstraint.isActive = true
    
    dismiss(animated: true, completion: nil)
    
    }
    
    //MARK: - 儲存新增的餐廳資料
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
               
               if nameTextField.text == "" || typeTextField.text == "" || addressTextField.text == "" || phoneTextField.text == "" || descriptionTextView.text == "" {
                   let alertController = UIAlertController(title: "Oops", message: "We can't proceed because one of the fields is blank. Please note that all fields are required.", preferredStyle: .alert)
                   let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                   alertController.addAction(alertAction)
                   present(alertController, animated: true, completion: nil)
                   
                   return
               }
               
               print("Name: \(nameTextField.text ?? "")")
               print("Type: \(typeTextField.text ?? "")")
               print("Location: \(addressTextField.text ?? "")")
               print("Phone: \(phoneTextField.text ?? "")")
               print("Description: \(descriptionTextView.text ?? "")")

        //託管物件 - 儲存新資訊至資料庫
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            
            NewRestaurant = RestaurantMO(context: appDelegate.persistentContainer.viewContext)
            NewRestaurant.name = nameTextField.text
            NewRestaurant.type = typeTextField.text
            NewRestaurant.location = addressTextField.text
            NewRestaurant.phone = phoneTextField.text
            NewRestaurant.summary = descriptionTextView.text
            NewRestaurant.isVisited = false
            
            if let restaurantImage = photoImageView.image {
                NewRestaurant.image = restaurantImage.pngData()
            }
            
            print("Saving data to contect..")
            appDelegate.saveContext()
        }
               saveRecordToCloud(NewRestaurant: NewRestaurant)
               dismiss(animated: true, completion: nil)
           }
    
    //MARK: - 上傳資料至iCloud
       
    func saveRecordToCloud(NewRestaurant: RestaurantMO!) -> Void {
        
        //準備要儲存的資料
        let record = CKRecord(recordType: "Restaurant")
        record.setValue(NewRestaurant.name, forKey: "name")
        record.setValue(NewRestaurant.type, forKey: "type")
        record.setValue(NewRestaurant.location, forKey: "location")
        record.setValue(NewRestaurant.phone, forKey: "phone")
        record.setValue(NewRestaurant.summary, forKey: "description")
        
        let imageData = NewRestaurant.image! as Data
        
        //調整圖片大小
        let originalImage = UIImage(data: imageData)!
        let scalingFactor = (originalImage.size.width > 1024) ? 1024 / originalImage.size.width : 1.0
        let scaledImage = UIImage(data: imageData, scale: scalingFactor)!
        
        //將圖片寫進本地端檔案，作為暫時使用
        let imageFilePath = NSTemporaryDirectory() + NewRestaurant.name!
        let imageFileURL = URL(fileURLWithPath: imageFilePath)
        try? scaledImage.jpegData(compressionQuality: 0.8)?.write(to: imageFileURL)
        
        //建立要上傳的圖片資料
        let imageAsset = CKAsset(fileURL: imageFileURL)
        record.setValue(imageAsset, forKey: "image")
        
        //讀取iCloud公共資料庫
        let publicDatabase = CKContainer(identifier: "iCloud.com.Steven-QI.FoodPin").publicCloudDatabase
        
        
        //儲存資料至iCloud
        publicDatabase.save(record, completionHandler: { (record, error) -> Void in
            //移除暫存檔
            try? FileManager.default.removeItem(at: imageFileURL)
            
        })
    }
    
}
