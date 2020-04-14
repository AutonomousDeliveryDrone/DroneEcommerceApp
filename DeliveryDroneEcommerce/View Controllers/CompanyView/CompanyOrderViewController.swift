//
//  CompanyOrderViewController.swift
//  DeliveryDroneEcommerce
//
//  Created by Gavin Wong on 4/13/20.
//  Copyright © 2020 Michael Peng. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class CompanyOrderViewController: UIViewController {

    var orders : [CompanyOrder] = []
    @IBOutlet weak var tableView: UITableView!
    
    var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        ref = Database.database().reference()
        retrieveOrders()
        
        tableView.register(UINib(nibName: "CompanyOrderCell", bundle: nil), forCellReuseIdentifier: "CompanyOrderCell")

        // Do any additional setup after loading the view.
    }
    
    func retrieveOrders () {
        ref.child("Orders").child("Companies").child(Auth.auth().currentUser!.uid).queryOrdered(byChild: "Price").observeSingleEvent(of: .value) { (snapshot) in
                    //gettin the companyID
        //            let post = Post.init(key: snapshot.key, date: snapshot.value!["date"] as! String, postedBy: snapshot.value!["postedBy"] as! String, status: snapshot.value!["status"] as! String)

        //            let post = Post.init(key: snapshot.key, date: snapshot.value!["date"] as! String, postedBy: snapshot.value!["postedBy"] as! String, status: snapshot.value!["status"] as! String)

                    
                    print("loop")
                    for children in snapshot.children.allObjects as! [DataSnapshot] {
                        guard let value = children.value as? NSDictionary else {
                            print("could not collect data")
                            return
                        }
                        
                        let companyID = value["companyID"] as! String
                        print("----------------")
                        print(companyID)
                        print("----------------")
                        let price = value["Price"] as! Int
                        let product = value["Product"] as! String
                        let place = value["Place"] as! Int
                        let desc = value["Description"] as! String
                        let address = value["Address"] as! String
                        let time = value["Time"] as! String
                        
                        
                        //making the company cells
                        self.ref.child("UserInfo").child(companyID).child("Information").observeSingleEvent(of: .value) { (snap) in
                            guard let val = snap.value as? NSDictionary else {
                                print("could not collect data")
                                return
                            }
                            let Name = val["Company"] as! String
                            let Image = val["CompanyImage"] as! String
                            
                            let order = CompanyOrder(productName: product, price: price, address: address, time: time, place: place)
                            self.orders.append(order)
                            self.orders.sort(by: {$0.place < $1.place})
                            print("Prduct:" + product)
                            self.tableView.reloadData()
                        }
                    }
                    
                }
    }
    


}

extension CompanyOrderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyOrderCell", for: indexPath) as! CompanyOrderCell
//        cell.productDescription.text = orders[indexPath.row].description
        cell.productName.text = orders[indexPath.row].productName
        cell.customerAddress.text = orders[indexPath.row].address
        cell.timePurchased.text = orders[indexPath.row].time
//        cell.customerName.text = orders[indexPath.row].customerName
        cell.price.text = "$\(orders[indexPath.row].price)"
        return cell
    }
    
    
}

extension CompanyOrderViewController: UITableViewDelegate {
    
}
