//
//  UserHomeViewController.swift
//  DeliveryDroneEcommerce
//
//  Created by Michael Peng on 4/8/20.
//  Copyright © 2020 Michael Peng. All rights reserved.
//

import UIKit

class UserHomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var categories: [Category] = [
        Category(categoryType: "Food"),
        Category(categoryType: "Supplies"),
        Category(categoryType: "Gadgets"),
        Category(categoryType: "Clothings"),
        Category(categoryType: "Stationaries")
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        // Do any additional setup after loading the view.
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

extension UserHomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
        //might need to change later if we decide to add more categories
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].categoryType
        return cell
    }
}

extension UserHomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
