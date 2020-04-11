//
//  DisplayedCompanyViewController.swift
//  DeliveryDroneEcommerce
//
//  Created by Michael Peng on 4/10/20.
//  Copyright © 2020 Michael Peng. All rights reserved.
//

import UIKit
import Firebase

class DisplayedCompanyViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var companies: [CompanyCell] = [
       ]
    
    var category: String = "" //Will get filled out during segue
    var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        ref = Database.database().reference()
        
        tableView.register(UINib(nibName: "CompanyCell", bundle: nil), forCellReuseIdentifier: "CompanyCell")
    

        // Do any additional setup after loading the view.
    }
    
    func retrieveCompanies () {
        self.ref.child("Storage").child(category).observeSingleEvent(of: .value) { (snapshot) in
            //gettin the companyID
            for children in snapshot.children.allObjects as! [DataSnapshot] {
                guard let value = children.value as? NSDictionary else {
                    print("could not collect data")
                    return
                }
                
                let companyID = value["companyID"] as! String
                
                //making the company cells
                self.ref.child("UserInfo").child(companyID).child("Information").observeSingleEvent(of: .value) { (snap) in
                    guard let val = snapshot.value as? NSDictionary else {
                        print("could not collect data")
                        return
                    }
                    
                    
                }
            }
        }
        
        
    }
    

//func retrieveData() {
//        print(Auth.auth().currentUser!.uid)
//        self.ref.child("UserInfo").child(Auth.auth().currentUser!.uid).child("Products").observeSingleEvent(of: .value, with: { (snapshot) in
//            for children in snapshot.children.allObjects as! [DataSnapshot] {
////                print(snapshot)
//                guard let value = children.value as? NSDictionary else {
//                    print("could not collect label data")
//                    return
//                }
//
//                let amount = value["Amount"] as! Int
//                let company = value["Company"] as! String
//                let desc = value["Description"] as! String
//                let index = value["Index"] as! Int
//                let link = value["Link"] as! String
//                let name = value["Product"] as! String
//                let price = value["Price"] as! Int
//                let category = value["Category"] as! String
//                let compID = value["companyID"] as! String
//
//
//                let productStorage = Product(name: name, price: price, amount: amount, desc: desc, link: link, company: company, category: category, companyID: compID, index: index)
//
//                self.productList.append(productStorage)
//                self.tableView.reloadData()
//            }
//        }) { (error) in
//            print("error:\(error.localizedDescription)")
//        }
//    }
}

extension DisplayedCompanyViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyCell", for: indexPath) as! CompanyCell
        return cell
    }
    
    
}
