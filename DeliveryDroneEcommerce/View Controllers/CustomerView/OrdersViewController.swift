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
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        ref = Database.database().reference()
        
        retrieveOrders()
        
        tableView.register(UINib(nibName: "CustomerOrderCell", bundle: nil), forCellReuseIdentifier: "CustomerOrderCell")
    }
    
    //Mike do this part. Goes with firebase part
    func retrieveOrders() {
        ref.child("Orders").child("Users").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value) { (snapshot) in
            //gettin the companyID
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
                
                
                
                //making the company cells
                self.ref.child("UserInfo").child(companyID).child("Information").observeSingleEvent(of: .value) { (snap) in
                    guard let val = snap.value as? NSDictionary else {
                        print("could not collect data")
                        return
                    }
                    let Name = val["Company"] as! String
                    let Image = val["CompanyImage"] as! String
                    
                    let order = Order(name: product, company: Name , cost: price, image: Image)
                    self.orders.append(order)
                    print("Prduct:" + product)
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
}

extension OrdersViewController: UITableViewDelegate {
    
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
        cell.productImage?.sd_setImage(with: URL(string: orders[indexPath.row].image), placeholderImage: UIImage(named: "Companies"), options: .highPriority, progress: nil, completed: { (downloadImage, downloadException, cacheType, downloadURL) in
            
            if let downloadException = downloadException {
                print("Error downloading an image: \(downloadException.localizedDescription)")
            } else {
                print("Succesfully donwloaded image")
            }
        })
        return cell
    }
    
    
}
