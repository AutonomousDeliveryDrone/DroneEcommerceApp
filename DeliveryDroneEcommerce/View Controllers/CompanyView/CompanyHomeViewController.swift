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
    
    var company : String = ""
    var categoryType : String = ""
    var name1 : String = ""
    var price1 : Int = 0
    var desc1 : String = ""
    var link1 : String = ""
    var index1 : Int = 0
    var imageURL : String = ""
    var amount1 : Int = 0
    var compID : String  = ""
    
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
                let image = value["ProductImage"] as! String
                
                
                let productStorage = Product(name: name, price: price, amount: amount, desc: desc, link: link, company: company, category: category, companyID: compID, index: index, productImage: image)
                
                self.productList.append(productStorage)
                self.tableView.reloadData()
            }
        }) { (error) in
            print("error:\(error.localizedDescription)")
        }
    }
    
    
    
    
    @IBAction func signOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "companyBack", sender: self)
            
        }catch let signOutError as NSError {
            print("Logout Error")
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toProdView") {
            let secondVC = segue.destination as! CompanyProductViewController
            secondVC.company = company
            secondVC.categoryType = categoryType
            secondVC.name = name1
            secondVC.price = price1
            secondVC.desc = desc1
            secondVC.link = link1
            secondVC.index = index1
            secondVC.url = imageURL
            secondVC.amount = amount1
            secondVC.compID = compID
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
        
        let imageURL = current.productImage
        cell.prodImage?.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "Products"), options: .highPriority, progress: nil, completed: { (downloadImage, downloadException, cacheType, downloadURL) in
            
            if let downloadException = downloadException {
                print("Error downloading an image: \(downloadException.localizedDescription)")
            } else {
                print("Succesfully donwloaded image")
            }
        })
        
        
        
        //        cell.categoryLabel.text = categories[indexPath.row].categoryType
        //        cell.categoryImage.image = images[indexPath.row]
        return cell
    }
}

extension CompanyHomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        name1 = productList[indexPath.row].name
        price1 = productList[indexPath.row].price
        desc1 = productList[indexPath.row].desc
        link1 = productList[indexPath.row].link
        index1 = productList[indexPath.row].index
        imageURL = productList[indexPath.row].productImage
        amount1 = productList[indexPath.row].amount
        compID = productList[indexPath.row].companyID
        performSegue(withIdentifier: "toProdView", sender: self)
        print(indexPath.row)
    }
}

