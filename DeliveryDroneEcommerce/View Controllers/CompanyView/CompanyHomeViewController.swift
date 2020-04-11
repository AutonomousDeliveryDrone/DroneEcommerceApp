//
//  CompanyHomeViewController.swift
//  DeliveryDroneEcommerce
//
//  Created by Michael Peng on 4/9/20.
//  Copyright © 2020 Michael Peng. All rights reserved.
//

import UIKit
import Firebase

class CompanyHomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var ref: DatabaseReference!
    
    
    var productList: [Product] = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ProductCellTableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableCell2" )
        ref = Database.database().reference()
        retrieveData()
        

        // Do any additional setup after loading the view.
    }
    
    
    func retrieveData() {
        print(Auth.auth().currentUser!.uid)
        self.ref.child("UserInfo").child(Auth.auth().currentUser!.uid).child("Products").observeSingleEvent(of: .value, with: { (snapshot) in
            //        print("retrieve data: " + String(Data.childrenCount))
            //
            for children in snapshot.children.allObjects as! [DataSnapshot] {
//                print(snapshot)
                guard let value = children.value as? NSDictionary else {
                    print("could not collect label data")
                    return
                }
                
                let amount = value["Amount"] as! Int
                let company = value["Company"] as! String
                let desc = value["Description"] as! String
                let index = value["Index"] as! Int
                let link = value["Link"] as! String
                let name = value["Product"] as! String
                let price = value["Price"] as! Int
                let category = value["Category"] as! String
                let compID = value["companyID"] as! String
                
                
                let productStorage = Product(name: name, price: price, amount: amount, desc: desc, link: link, company: company, category: category, companyID: compID, index: index)
                
                self.productList.append(productStorage)
                self.tableView.reloadData()
            }
        }) { (error) in
            print("error:\(error.localizedDescription)")
        }
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



extension CompanyHomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
        //might need to change later if we decide to add more categories
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell2", for: indexPath) as! ProductCellTableViewCell
        
        let current : Product = productList[indexPath.row]
        
        cell.title.text = current.name
        cell.price.text = "$\(String(current.price)).00"
        cell.category.text = current.category
        cell.amount.text = "Left: \(String(current.amount))"
        
        
        
        //        cell.categoryLabel.text = categories[indexPath.row].categoryType
        //        cell.categoryImage.image = images[indexPath.row]
        return cell
    }
}

extension CompanyHomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

