//
//  OrdersViewController.swift
//  DeliveryDroneEcommerce
//
//  Created by Gavin Wong on 4/12/20.
//  Copyright © 2020 Michael Peng. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class OrdersViewController: UIViewController {
    
    var orders: [Order] = []
    var ref : DatabaseReference!
    @IBOutlet weak var tableView: UITableView!
    
    var company : String = ""
    var time : String = ""
    var name : String = ""
    var address : String = ""
    var price : Int = 0
    var dist : Int = 0
    
    var status : String = ""
    var companyID : String = ""
    var userID : String = ""
    var place : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        ref = Database.database().reference()
        
        retrieveOrders()
        
        tableView.register(UINib(nibName: "CustomerOrderCell", bundle: nil), forCellReuseIdentifier: "CustomerOrderCell")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toOrderProgress") {
            let secondVC = segue.destination as! ProgressScreenViewController
            secondVC.company = company
            secondVC.timeOrdered = time
            secondVC.productName = name
            secondVC.price = price
            secondVC.address = address
            secondVC.distIndex = dist
            secondVC.userID = userID
            secondVC.companyID = companyID
            secondVC.status = status
            secondVC.place = place
            
        }
    }
    //Mike do this part. Goes with firebase part
    func retrieveOrders() {
        orders = []
        ref.child("Orders").child("Users").child(Auth.auth().currentUser!.uid).queryOrdered(byChild: "Price").observeSingleEvent(of: .value) { (snapshot) in
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
                let name = value["CustomerName"] as! String
                let time = value["Time"] as! String
                let userID = value["UserID"] as! String
                let status = value["Status"] as! String
                let compID = value["companyID"] as! String
                let dist = value["DistanceIndex"] as! Int
                
                
                //making the company cells
                self.ref.child("UserInfo").child(companyID).child("Information").observeSingleEvent(of: .value) { (snap) in
                    guard let val = snap.value as? NSDictionary else {
                        print("could not collect data")
                        return
                    }
                    let Name = val["Company"] as! String
                    let Image = val["CompanyImage"] as! String
                    
                    let order = Order(name: product, company: Name , cost: price, image: Image, place: place, status: status, userID: userID, companyID: compID, time: time, address: address, distIndex: dist)
                    self.orders.append(order)
                    self.orders.sort(by: {$0.place < $1.place})
                    print("Prduct:" + product)
                    self.tableView.reloadData()
                }
            }
            
        }
        
    }
    
}

extension OrdersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerOrderCell", for: indexPath) as! CustomerOrderCell
        cell.productName.text = orders[indexPath.row].name
        cell.cost.text = "$\(orders[indexPath.row].cost)"
        cell.company.text = orders[indexPath.row].company
        cell.time.text = orders[indexPath.row].time
        cell.address.text = orders[indexPath.row].address
        
        
        cell.status.text = "Status:\(orders[indexPath.row].status)"
        return cell
    }
    
    
}


extension OrdersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        company = orders[indexPath.row].company
        address = orders[indexPath.row].address
        price = orders[indexPath.row].cost
        name = orders[indexPath.row].name
        time = orders[indexPath.row].time
        dist = orders[indexPath.row].distIndex
        status = orders[indexPath.row].status
        companyID = orders[indexPath.row].companyID
        userID = orders[indexPath.row].userID
        place = orders[indexPath.row].place
        print(orders[indexPath.row].status)
        performSegue(withIdentifier: "toOrderProgress", sender: self)
        //                if orders[indexPath.row].status == "In Transit" {
        //            let alert = UIAlertController(title: "Complete Order", message: "Did the product deliver to your house yet?", preferredStyle: .alert)
        //
        //            let change = UIAlertAction(title: "Complete", style: .default) { (alert) in
        //                self.ref.child("Orders").child("Users").child(self.orders[indexPath.row].userID).child(String(self.orders[indexPath.row].place)).removeValue()
        //                self.ref.child("Orders").child("Companies").child(self.orders[indexPath.row].companyID).child(String(self.orders[indexPath.row].place)).removeValue()
        //                self.retrieveOrders()
        //                self.tableView.reloadData()
        //
        //            }
        //            let cancel = UIAlertAction(title: "Cancel", style: .default) { (alert) in
        //                return
        //            }
        //
        //            alert.addAction(change)
        //            alert.addAction(cancel)
        //            self.present(alert, animated: true, completion: nil)
        //            print(indexPath.row)
        //        }
    }
}



