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

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "CompanyOrderCell", bundle: nil), forCellReuseIdentifier: "CompanyOrderCell")

        // Do any additional setup after loading the view.
    }
    


}

extension CompanyOrderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyOrderCell", for: indexPath) as! CompanyOrderCell
        return cell
    }
    
    
}

extension CompanyOrderViewController: UITableViewDelegate {
    
}
