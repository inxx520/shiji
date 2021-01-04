//
//  AddRestaurantController.swift
//  shiji
//
//  Created by 小仙女 on 20/12/2019.
//  Copyright © 2019 cyper tech. All rights reserved.
//

import UIKit
import CloudKit

class AddRestaurantController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    var isVisited = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                
                imagePicker.delegate = self
                
                present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photoImageView.image = selectedImage
            photoImageView.contentMode = .scaleAspectFill
            photoImageView.clipsToBounds = true
        }
        
       
        let superview = photoImageView.superview
        
        let leading = NSLayoutConstraint(item: photoImageView, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1, constant: 0)
        leading.isActive = true
        
        let trailing = NSLayoutConstraint(item: photoImageView, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1, constant: 0)
        trailing.isActive = true
        
        let top = NSLayoutConstraint(item: photoImageView, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: 0)
        top.isActive = true
        
        let bottom = NSLayoutConstraint(item: photoImageView, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1, constant: 0)
        bottom.isActive = true
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didClickYesNoButton(_ sender: UIButton) {
        if sender == yesButton {
            yesButton.layer.cornerRadius = 4.0;
            noButton.layer.cornerRadius = 4.0;
            yesButton.backgroundColor = UIColor.red
            noButton.backgroundColor = UIColor.lightGray
            isVisited = true
        } else {
            yesButton.layer.cornerRadius = 4.0;
            noButton.layer.cornerRadius = 4.0;
            noButton.backgroundColor = UIColor.red
            yesButton.backgroundColor = UIColor.lightGray
            isVisited = false
        }
        
    }

    
    @IBAction func saveRestaurant() {
        let restaurant = saveToLocalOrFail()
        if restaurant != nil {
            saveRecordToCloud(restaurant: restaurant)
            
            
            performSegue(withIdentifier: "unwindToHomeScreen", sender: self)
            
        } else {
            let controller = UIAlertController(title: "提醒", message: "你还有空没有填上哟~", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "收到", style: .default, handler: nil))
            present(controller, animated: true, completion: nil)
        }
    }
    
    func saveRecordToCloud(restaurant: RestaurantMO!) {
       
        let record =  CKRecord(recordType: "Restaurant")
        record.setValue(restaurant.name, forKey: "name")
        record.setValue(restaurant.type, forKey: "type")
        record.setValue(restaurant.location, forKey: "location")
        record.setValue(restaurant.phone, forKey: "phone")
        
        let imageData = restaurant.image as! Data
        

        let originalImage = UIImage(data: imageData)!
        let scalingFactor = (originalImage.size.width > 1024) ? 1024 / originalImage.size.width : 1.0
        let scaledImage = UIImage(data: imageData, scale: scalingFactor)!
               let imageFilePath = NSTemporaryDirectory() + restaurant.name!
        let imageFileURL = URL(fileURLWithPath: imageFilePath)
        try? UIImageJPEGRepresentation(scaledImage, 0.8)?.write(to: imageFileURL)
        

        let imageAsset = CKAsset(fileURL: imageFileURL)
        record.setValue(imageAsset, forKey: "image")
        
        
    }
    
    func saveToLocalOrFail() -> RestaurantMO? {
        guard let name = nameTextField.text, !name.isEmpty else {
            return nil
        }
        guard let type = typeTextField.text, !type.isEmpty else {
            return nil
        }
        
        guard let location = locationTextField.text, !location.isEmpty else {
            return nil
        }
        
        
        let restaurant = RestaurantMO(context: CD.ctx)
        restaurant.name = name
        restaurant.type = type
        restaurant.location = location
        restaurant.phone = phoneTextField.text
        restaurant.isVisited = isVisited
        restaurant.image = CD.image2Data(image: photoImageView.image)
        CD.save(restaurant)
        
        
        return restaurant
    }
    
    

}
