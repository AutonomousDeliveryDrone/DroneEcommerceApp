//
//  LoginViewController.swift
//  DeliveryDroneEcommerce
//
//  Created by Michael Peng on 4/8/20.
//  Copyright © 2020 Michael Peng. All rights reserved.
//

import UIKit
import Firebase
import BetterSegmentedControl

class LoginViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
//    @IBOutlet weak var `switch`: BetterSegmentedControl!
    @IBOutlet weak var regSwitch: BetterSegmentedControl!
    
    
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        let control = BetterSegmentedControl(frame: CGRect(x: 0, y: 0, width: 300, height: 44), segments: LabelSegment.segments(withTitles: ["One", "Two", "Three"],
//        normalFont: UIFont(name: "HelveticaNeue-Light", size: 14.0)!,
//        normalTextColor: .lightGray,
//        selectedFont: UIFont(name: "HelveticaNeue-Bold", size: 14.0)!,
//        selectedTextColor: .white),
//        index: 1,
//        options: [.backgroundColor(.darkGray),
//                  .indicatorViewBackgroundColor(.blue)])
//
        
        
        loginButton.layer.cornerRadius = accountButton.frame.height / 3
        loginButton.layer.shadowColor = UIColor.black.cgColor
        loginButton.layer.shadowRadius = 5
        loginButton.layer.shadowOpacity = 0.7
        
        accountButton.layer.cornerRadius = accountButton.frame.height / 3
        accountButton.layer.shadowColor = UIColor.black.cgColor
        accountButton.layer.shadowRadius = 5
        accountButton.layer.shadowOpacity = 0.7
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .medium
        formatter.locale = Locale(identifier: "en_US")
        let time = formatter.string(from: date)

        
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func login(_ sender: Any) {
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
            if (error == nil) {
                
                self.ref.child("UserInfo").child(Auth.auth().currentUser!.uid).child("Information").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    guard let value = snapshot.value as? NSDictionary else {
                        print("No Data!!!")
                        return
                    }
                    let status = value["Status"] as! String
                    
                    
                    print (status)
                    if (status == "User") {
                        self.performSegue(withIdentifier: "toUserHome", sender: self)
                    }
                    else {
                        self.performSegue(withIdentifier: "toCompanyHome", sender: self)
                    }
                    
                    
                }) { (error) in
                    print("error:\(error.localizedDescription)")
                }
                //
                
            } else {
                
                
                let alert = UIAlertController(title: "Login Error", message: "Incorrect username or password", preferredStyle: .alert)
                let forgotPassword = UIAlertAction(title: "Forgot Password?", style: .default, handler: { (UIAlertAction) in
                    //do the forgot password shit
                })
                
                let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { (UIAlertAction) in
                    //do nothing
                })
                
                alert.addAction(forgotPassword)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
                print("error with logging in: ", error!)
            }
            
        }
        
        
    }
    @IBAction func switchAction(_ sender: Any) {
        
    }
    /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
}
