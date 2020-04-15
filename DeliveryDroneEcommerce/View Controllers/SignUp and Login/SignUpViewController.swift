//
//  ViewController.swift
//  DeliveryDroneEcommerce
//
//  Created by Michael Peng on 4/8/20.
//  Copyright © 2020 Michael Peng. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var FirstName: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var ShippingAddress: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var accountButton: UIButton!
    
    var ref: DatabaseReference!
    
    var isUser : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        button.layer.shadowColor = UIColor.blue.cgColor
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.5
       // button.addTarget(self, action: #selector(self.animate(sender:)), for: .touchUpInside)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 3.0
        button.layer.borderColor = UIColor.darkGray.cgColor
        
        signUpButton.layer.cornerRadius = signUpButton.frame.height / 3
        signUpButton.layer.shadowColor = UIColor.darkGray.cgColor
        signUpButton.layer.shadowRadius = 10
        signUpButton.layer.shadowOpacity = 0.7
        
        accountButton.layer.cornerRadius = accountButton.frame.height / 3
        accountButton.layer.shadowColor = UIColor.black.cgColor
        accountButton.layer.shadowRadius = 5
        accountButton.layer.shadowOpacity = 0.7

        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUp(_ sender: Any) {
        if (FirstName.text?.isEmpty ?? true || LastName.text?.isEmpty ?? true || emailAddress.text?.isEmpty ?? true || password.text?.isEmpty ?? true) {
            print("THERE IS AN ERROR")
            let alert = UIAlertController(title: "Registration Error", message: "Please make sure you have completed filled out every textfield", preferredStyle: .alert)
            
            let OK = UIAlertAction(title: "OK", style: .default) { (alert) in
                return
            }
            
            alert.addAction(OK)
            self.present(alert, animated: true, completion: nil)
            
        } else {
            Auth.auth().createUser(withEmail: emailAddress.text!, password: password.text!) { (user, error) in
                if (error == nil) {
                    self.ref.child("UserInfo").child(Auth.auth().currentUser!.uid).child("Information").setValue(["FirstName" : self.FirstName.text, "LastName" : self.LastName.text, "Address" : self.ShippingAddress.text, "Email" : self.emailAddress.text])
                    self.ref.child("UserInfo").child(Auth.auth().currentUser!.uid).child("Information").updateChildValues(["Status" : "User"])
                    

                    
                    self.performSegue(withIdentifier: "UserToLogin", sender: self)
                    //                    self.performSegue(withIdentifier: "goToMainMenu", sender: self)
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
    
    //@objc func animate(sender: UIButton) {
//        self.animateView(sender)
//    }
//    func animateView(_ viewToAnimate: UIView) {
//        UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
//
//            viewToAnimate.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
//        }) { (_) in
//            UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 2, options: .curveEaseIn, animations: {
//                viewToAnimate.transform = CGAffineTransform(scaleX: 1, y: 1)
//            }, completion: nil)
//        }
//    }
//
    @IBAction func registerCompany(_ sender: Any) {
        
    }
}

