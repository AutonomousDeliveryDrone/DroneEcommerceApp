//
//  CompanySignUpViewController.swift
//  DeliveryDroneEcommerce
//
//  Created by Michael Peng on 4/9/20.
//  Copyright © 2020 Michael Peng. All rights reserved.
//

import UIKit
import Firebase

class CompanySignUpViewController: UIViewController {
    
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var CeoName: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
    var ref: DatabaseReference!
    var isFood : Bool = false
    var isSupplies : Bool = false
    var isGadgets : Bool = false
    var isClothing : Bool = false
    var isStationaries : Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
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
    @IBAction func signUp(_ sender: Any) {
        if (Name.text?.isEmpty ?? true || CeoName.text?.isEmpty ?? true || location.text?.isEmpty ?? true || email.text?.isEmpty ?? true || password.text?.isEmpty ?? true) {
            print("THERE IS AN ERROR")
            let alert = UIAlertController(title: "Registration Error", message: "Please make sure you have completed filled out every textfield", preferredStyle: .alert)
            
            let OK = UIAlertAction(title: "OK", style: .default) { (alert) in
                return
            }
            
            alert.addAction(OK)
            self.present(alert, animated: true, completion: nil)
            
        } else {
            Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (user, error) in
                if (error == nil) {
                    self.ref.child("UserInfo").child(Auth.auth().currentUser!.uid).child("Information").setValue(["Company" : self.Name.text, "CEO" : self.CeoName.text, "Address" : self.location.text, "Email" : self.email.text])
                    self.ref.child("UserInfo").child(Auth.auth().currentUser!.uid).child("Information").updateChildValues(["Status":"Company"])
                    self.ref.child("UserInfo").child(Auth.auth().currentUser!.uid).child("Products").updateChildValues(["Index": 1])
                    
                    if (self.isFood) {
                        self.ref.child("Storage").child("Food").child(Auth.auth().currentUser!.uid).updateChildValues(["Index" : 1])
                    }
                    if (self.isSupplies) {
                        self.ref.child("Storage").child("Supplies").child(Auth.auth().currentUser!.uid).updateChildValues(["Index" : 1])
                    }
                    if (self.isGadgets) {
                        self.ref.child("Storage").child("Gadgets").child(Auth.auth().currentUser!.uid).updateChildValues(["Index" : 1])
                    }
                    if (self.isClothing) {
                        self.ref.child("Storage").child("Clothing").child(Auth.auth().currentUser!.uid).updateChildValues(["Index" : 1])
                    }
                    if (self.isStationaries) {
                        self.ref.child("Storage").child("Stationaries").child(Auth.auth().currentUser!.uid).updateChildValues(["Index" : 1])
                    }
                    if (!self.isFood && !self.isStationaries && !self.isClothing && !self.isSupplies && !self.isGadgets ) {
                        let alert = UIAlertController(title: "Registration Error", message: "Please select a delivery category to register", preferredStyle: .alert)
                        
                        let OK = UIAlertAction(title: "OK", style: .default) { (alert) in
                            return
                        }
                        
                        alert.addAction(OK)
                        self.present(alert, animated: true, completion: nil)
                    }
                    self.performSegue(withIdentifier: "companyToLogin", sender: self)
                } else {
                    //                    SVProgressHUD.dismiss()
                    let alert = UIAlertController(title: "Registration Error", message: error?.localizedDescription as! String, preferredStyle: .alert)
                    
                    let OK = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                        self.password.text = ""
                    })
                    
                    alert.addAction(OK)
                    self.present(alert, animated: true, completion: nil)
                    print("--------------------------------")
                    print("Error: \(error?.localizedDescription)")
                    print("--------------------------------")
                }
            }
        }
    }
    
    @IBAction func foodSwitch(_ sender: Any) {
        isFood = !isFood
    }
    @IBAction func suppliesSwitch(_ sender: Any) {
        isSupplies = !isSupplies
    }
    @IBAction func gadgetsSwitch(_ sender: Any) {
        isGadgets = !isGadgets
    }
    @IBAction func clothingSwitch(_ sender: Any) {
        isClothing = !isClothing
    }
    @IBAction func stationariesSwitch(_ sender: Any) {
        isStationaries = !isStationaries
    }
    
}
