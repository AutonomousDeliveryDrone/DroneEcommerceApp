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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "CompanyOrderCell", bundle: nil), forCellReuseIdentifier: "CompanyOrderCell")

        // Do any additional setup after loading the view.
    }
    
    func retrieveOrders () {
        
    }
    


}

extension CompanyOrderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyOrderCell", for: indexPath) as! CompanyOrderCell
        cell.productDescription.text = orders[indexPath.row].description
        cell.productName.text = orders[indexPath.row].productName
        cell.customerAddress.text = orders[indexPath.row].address
        cell.customerName.text = orders[indexPath.row].customerName
        cell.price.text = orders[indexPath.row].price
        return cell
    }
    
    
}

extension CompanyOrderViewController: UITableViewDelegate {
    
}
