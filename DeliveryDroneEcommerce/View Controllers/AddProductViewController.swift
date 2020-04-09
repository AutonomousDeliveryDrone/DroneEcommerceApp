//
//  AddProductViewController.swift
//  DeliveryDroneEcommerce
//
//  Created by Michael Peng on 4/9/20.
//  Copyright © 2020 Michael Peng. All rights reserved.
//

import UIKit
import Firebase


class CellClass: UITableViewCell {
    
}
class AddProductViewController: UIViewController {
    
    
    @IBOutlet weak var productTitle: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var desc: UITextView!
    @IBOutlet weak var productLink: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var categoryButton: UIButton!
    
    var ref: DatabaseReference!
    
    let transparentView = UIView()
    let tableView = UITableView()
    
    var selectedButton = UIButton()
    
    var dataSource = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        ref.child("Storage").child("Gadgets").setValue(["Index":1])
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Add(_ sender: Any) {
        let categoryText = categoryButton.titleLabel?.text as! String
        print("yote:"+categoryText)
        if (productTitle.text?.isEmpty ?? true || price.text?.isEmpty ?? true || amount.text?.isEmpty ?? true || desc.text?.isEmpty ?? true || productLink.text?.isEmpty ?? true) {
            
            print("THERE IS AN ERROR")
            let alert = UIAlertController(title: "Error Detected", message: "Please make sure you have completed every field", preferredStyle: .alert)
            
            let OK = UIAlertAction(title: "OK", style: .default) { (alert) in
                return
            }
            
            alert.addAction(OK)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            //            ref.child("Storage").child(categoryText).setValue(["Index" : 1])
            let priceInt: Int? = Int(price.text!)
            let amountInt: Int? = Int(amount.text!)
            var productList = ["Product":productTitle.text, "Price": priceInt, "Amount":amountInt, "Description" : desc.text, "Link" : productLink.text] as [String : Any]
            
            self.ref.child("Storage").child(categoryText).observeSingleEvent(of: .value, with: { (snapshot) in
                

                guard let value = snapshot.value as? NSDictionary else {
                    print("No Data!!!")
                    return
                }
                let index = value["Index"] as! Int
                print("Index:"+String(index))
                self.ref.child("Storage").child(categoryText).child(String(index)).setValue(productList)
                self.ref.child("Storage").child(categoryText).updateChildValues(["Index" : index+1])
                
                self.ref.child("UserInfo").child(Auth.auth().currentUser!.uid).child("Orders").observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let value1 = snapshot.value as? NSDictionary else {
                        print("No Data!!!")
                        return
                    }
                    let i = value1["Index"] as! String

                    self.ref.child("UserInfo").child(Auth.auth().currentUser!.uid).child("Orders").child(i).updateChildValues(productList)



                }) { (error) in
                    print("error:\(error.localizedDescription)")
                }
                
                
                
                
                
                
                
            }) { (error) in
                print("error:\(error.localizedDescription)")
            }
            
        }
    }
    @IBAction func categoryChoose(_ sender: Any) {
        dataSource = ["Food", "Supplies", "Gadgets"]
        selectedButton = categoryButton
        addTransparentView(frames: categoryButton.frame)
    }
    
    func addTransparentView(frames: CGRect) {
        let window = UIApplication.shared.keyWindow
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
        
        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 5
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView.reloadData()
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(self.dataSource.count * 50))
        }, completion: nil)
    }
    
    @objc func removeTransparentView() {
        let frames = selectedButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        }, completion: nil)
    }
}


extension AddProductViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedButton.setTitle(dataSource[indexPath.row], for: .normal)
        removeTransparentView()
    }
}

