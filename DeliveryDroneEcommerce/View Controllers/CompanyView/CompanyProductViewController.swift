//
//  CompanyProductViewController.swift
//  DeliveryDroneEcommerce
//
//  Created by Michael Peng on 4/14/20.
//  Copyright © 2020 Michael Peng. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class CompanyProductViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    var company : String = ""
    var categoryType : String = ""
    var name : String = ""
    var price : Int = 0
    var desc : String = ""
    var link : String = ""
    var index : Int = 0
    var url : String = ""
    var amount : Int = 0
    var compID : String = ""
    var orderAmount: Int = 0
    
    var imageChanged : Bool = false
    var titleChanged : Bool = false
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDesc: UITextView!
    @IBOutlet weak var productLink: UILabel!
    @IBOutlet weak var restockAmount: UITextField!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var editButton: UIButton!
    
    var ref: DatabaseReference!
    var storageRef: StorageReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("-----------------")
        print(name + ".png")
        print("-----------------")
        priceTextField.keyboardType = UIKeyboardType.numberPad
        restockAmount.keyboardType = UIKeyboardType.numberPad
        
        nameTextField.delegate = self
        ref = Database.database().reference()
        
        
        productName.text = name
        productPrice.text = "\(price)"
        productDesc.text = desc
        productLink.text = link
        
        productImage?.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "Products"), options: .highPriority, progress: nil, completed: { (downloadImage, downloadException, cacheType, downloadURL) in
            
            if let downloadException = downloadException {
                print("Error downloading an image: \(downloadException.localizedDescription)")
            } else {
                print("Succesfully donwloaded image")
            }
        })
        
        productImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        productImage.isUserInteractionEnabled = false
        
    
    }
    
    @objc func handleSelectProfileImageView () {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("selecting")
        imageChanged = true
        var selectedImageFromPicker: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage{
            selectedImageFromPicker = originalImage
        }

        if let selectedImage = selectedImageFromPicker {
            print("changing image")
            productImage.image = selectedImage
        }
        productImage.layer.borderWidth = 0
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imageChanged = false
        dismiss(animated: true, completion: nil)
    }

    @IBAction func add(_ sender: Any) {
        if let restockAmt = Int((self.restockAmount.text!)) {
            amount = amount + restockAmt
            ref.child("Storage").child(categoryType).child(compID).child(String(index)).updateChildValues(["Amount" : amount])
            ref.child(("UserInfo")).child(compID).child("Products").child(String(index)).updateChildValues(["Amount": amount])
            let alert = UIAlertController(title: "Success!", message: "Item has been restocked!", preferredStyle: .alert)
            
            let OK = UIAlertAction(title: "OK", style: .default) { (alert) in
                return
            }
            
            alert.addAction(OK)
            self.present(alert, animated: true, completion: nil)
        }
        restockAmount.text = ""
        
    }

    @IBAction func editPressed(_ sender: Any) {
        if (editButton.titleLabel?.text == "EDIT") {
            
            
            
            //Button Change
            editButton.setAttributedTitle(NSAttributedString(string: "DONE"), for: .normal)
            
            editButton.imageView?.isHidden = true
            
            //ProductImage
            productImage.isUserInteractionEnabled = true
            productImage.image = UIImage(named: "upload")
            
            //Title
            productName.isHidden = true
            nameTextField.isHidden = false
            nameTextField.text = productName.text
            
            //Price
            productPrice.isHidden = true
            priceTextField.isHidden = false
            priceTextField.text = productPrice.text
            
            //Description
            productDesc.isHidden = true
            descriptionTextField.isHidden = false
            descriptionTextField.text = productDesc.text
            
            //Link
            productLink.isHidden = true
            linkTextField.isHidden = false
            linkTextField.text = productLink.text
            
        } else {
            
            
            //Title
            if (productName.text != nameTextField.text) {
                titleChanged = true
            }
            productName.text = nameTextField.text!
            productName.isHidden = false
            nameTextField.isHidden = true
            
            //Price
            
            productPrice.text = priceTextField.text!
            productPrice.isHidden = false
            priceTextField.isHidden = true
            
            //Description
            productDesc.text = descriptionTextField.text!
            productDesc.isHidden = false
            descriptionTextField.isHidden = true
            
            //Link
            productLink.text = linkTextField.text!
            productLink.isHidden = false
            linkTextField.isHidden = true
            
            //Image + FirStorage
            productImage.isUserInteractionEnabled = false
            if (!imageChanged) {
                productImage?.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "Products"), options: .highPriority, progress: nil, completed: { (downloadImage, downloadException, cacheType, downloadURL) in
                    
                    if let downloadException = downloadException {
                        print("Error downloading an image: \(downloadException.localizedDescription)")
                    } else {
                        print("Succesfully donwloaded image")
                    }
                })
            } else {
                storageRef = Storage.storage().reference().child("ProductImages").child(compID).child(name + ".png")
                let deleteImg = storageRef
                print("BRAAYY")
                deleteImg!.delete { (error) in
                    if let error = error {
                        print("Error occured with deleting image")
                    }
                    if let uploadData = self.productImage.image?.pngData() {
                        print("storing image")
                        self.storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                            if (error != nil) {
                                
                                print(error)
                                return
                            }
                            self.storageRef.downloadURL(completion: { (url, error) in
                                if let err = error {
                                    print("there was an error")
                                    print(err)
                                } else {
                                    self.url = url!.absoluteString
                                    self.uploadImageURL(self.url)
                                }
                            })
                            
                            
                        }
                    }
                }
                imageChanged = false
            }
            
            ref.child("Storage").child(categoryType).child(compID).child(String(index)).updateChildValues(["Product": nameTextField.text!, "Price" : Int(priceTextField.text!), "Description": descriptionTextField.text!, "Link": linkTextField.text!])
            ref.child("UserInfo").child(compID).child("Products").child(String(index)).updateChildValues(["Product": nameTextField.text!, "Price" : Int(priceTextField.text!), "Description": descriptionTextField.text!, "Link": linkTextField.text!])
            nameTextField.text = ""
            editButton.setAttributedTitle(NSAttributedString(string: "EDIT"), for: .normal)
            editButton.imageView?.isHidden = false
            
        }
        
        
        
    }
    
    func uploadImageURL(_ url : String) {
        ref.child("Storage").child(categoryType).child(compID).child(String(index)).updateChildValues(["ProductImage" : url])
        ref.child("UserInfo").child(compID).child("Products").child(String(index)).updateChildValues(["ProductImage" : url])
    }
    

}

extension CompanyProductViewController: UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == nameTextField) {
            productName.text = textField.text!
            productName.isHidden = false
            textField.isHidden = true
            
            ref.child("Storage").child(categoryType).child(compID).child(String(index)).updateChildValues(["Product": textField.text!])
            ref.child("UserInfo").child(compID).child("Products").child(String(index)).updateChildValues(["Product": textField.text!])
            textField.text = ""
        }
    }
}
