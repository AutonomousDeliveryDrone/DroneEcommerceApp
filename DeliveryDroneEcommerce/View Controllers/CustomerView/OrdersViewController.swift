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

    var orders: [Order] = [Order(name: "Apples", company: "Walmart", cost: "15"),
                           Order(name: "Oranges", company: "Target", cost: "20")]
    var ref : DatabaseReference!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        ref = Database.database().reference()

        tableView.register(UINib(nibName: "CustomerOrderCell", bundle: nil), forCellReuseIdentifier: "CustomerOrderCell")
    }
    
    //Mike do this part. Goes with firebase part
    func retrieveOrders() {
        
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
        cell.cost.text = orders[indexPath.row].cost
        cell.company.text = orders[indexPath.row].company
        return cell
    }
    
    
}
