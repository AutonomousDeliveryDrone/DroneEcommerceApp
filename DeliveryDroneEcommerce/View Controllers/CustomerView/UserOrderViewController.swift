//
//  UserOrderViewController.swift
//  DeliveryDroneEcommerce
//
//  Created by Michael Peng on 4/11/20.
//  Copyright © 2020 Michael Peng. All rights reserved.
//

import UIKit
import Firebase

class UserOrderViewController: UIViewController {
    
    
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
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var productDesc: UITextView!
    @IBOutlet weak var productLink: UILabel!
    
    var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
//        ref.child("Orders").setValue(["orderNum" : 1])
        
        productName.text = name
        productPrice.text = "$" + String(price)
        productDesc.text = desc
        productLink.text = link
        
        productImage?.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "Products"), options: .highPriority, progress: nil, completed: { (downloadImage, downloadException, cacheType, downloadURL) in
            
            if let downloadException = downloadException {
                print("Error downloading an image: \(downloadException.localizedDescription)")
            } else {
                print("Succesfully donwloaded image")
            }
        })
        
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func orderPressed(_ sender: Any) {
        
        
        
        
        let productStorage = Product(name: name, price: price, amount: amount, desc: desc, link: link, company: company, category: categoryType, companyID: compID, index: index, productImage:url)
        
        
      
        self.ref.child("UserInfo").child(Auth.auth().currentUser!.uid).child("Information").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value as? NSDictionary else {
                print("No Data!")
                return
            }
            
            let address = value["Address"] as! String
            
            let productList = ["Product":productStorage.name, "Price": productStorage.price, "Amount":productStorage.amount, "Description" : productStorage.desc, "Link" : productStorage.link, "Company" : productStorage.company, "Index":productStorage.index, "Category": productStorage.category, "companyID" :productStorage.companyID, "ProductImage": productStorage.productImage, "Address" : address] as [String : Any]
            
            self.ref.child("Orders").observeSingleEvent(of: .value, with: { (snapshot1) in
                guard let value0 = snapshot1.value as? NSDictionary else {
                    print("No Data!")
                    return
                }
                let place = value0["orderNum"] as! Int
                
                self.ref.child("Orders").child("Users").child(Auth.auth().currentUser!.uid).child(String(place)).updateChildValues(productList)
                
                
                self.ref.child("Orders").child("Companies").child(self.compID).child(String(place)).updateChildValues(productList)
                self.ref.child("Orders").updateChildValues(["orderNum" : place+1])
                
                
            })
        })
    }
    
    
    
    
}
