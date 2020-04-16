//
//  CompanyProductViewController.swift
//  DeliveryDroneEcommerce
//
//  Created by Michael Peng on 4/14/20.
//  Copyright © 2020 Michael Peng. All rights reserved.
//

import UIKit
import Firebase

class CompanyProductViewController: UIViewController {

    
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
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDesc: UITextView!
    @IBOutlet weak var productLink: UILabel!
    @IBOutlet weak var restockAmount: UITextField!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameButton: UIButton!
    
    
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restockAmount.keyboardType = UIKeyboardType.numberPad
        
        nameTextField.delegate = self
        print("------------")
        print(nameButton.titleLabel?.text)
        print("---------")
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
    @IBAction func editTitle(_ sender: Any) {
        if (nameButton.titleLabel?.text == "EDIT") {
            productName.isHidden = true
            nameTextField.isHidden = false
            nameTextField.text = productName.text
            nameButton.setAttributedTitle(NSAttributedString(string: "DONE"), for: .normal)
        } else {
            productName.text = nameTextField.text!
            productName.isHidden = false
            nameTextField.isHidden = true
            
        ref.child("Storage").child(categoryType).child(compID).child(String(index)).updateChildValues(["Product": nameTextField.text!])
            ref.child("UserInfo").child(compID).child("Products").child(String(index)).updateChildValues(["Product": nameTextField.text!])
                nameTextField.text = ""
            nameButton.setAttributedTitle(NSAttributedString(string: "EDIT"), for: .normal)
            
        }
        
        
        
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
