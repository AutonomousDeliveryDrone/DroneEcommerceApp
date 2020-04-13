//
//  DisplayedCompanyViewController.swift
//  DeliveryDroneEcommerce
//
//  Created by Michael Peng on 4/10/20.
//  Copyright © 2020 Michael Peng. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class DisplayedCompanyViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var companies: [Company] = []
    
    var category: String = "" //Will get filled out during segue
    
    var companySelected : String = ""
    
    
    
    
    var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        ref = Database.database().reference()
        
        tableView.register(UINib(nibName: "CompanyCell", bundle: nil), forCellReuseIdentifier: "CompanyCell")
        retrieveCompanies()

        // Do any additional setup after loading the view.
    }
    
    func retrieveCompanies() {
        print("CAT: "+category)
        self.ref.child("Storage").child(category).observeSingleEvent(of: .value) { (snapshot) in
            //gettin the companyID
            print("getting companyID")
            for children in snapshot.children.allObjects as! [DataSnapshot] {
                guard let value = children.value as? NSDictionary else {
                    print("could not collect data")
                    return
                }

                let companyID = value["companyID"] as! String
                print("----------------")
                print(companyID)
                print("----------------")

                //making the company cells
                self.ref.child("UserInfo").child(companyID).child("Information").observeSingleEvent(of: .value) { (snap) in
                    guard let val = snap.value as? NSDictionary else {
                        print("could not collect data")
                        return
                    }
                    let Name = val["Company"] as! String
                    let Image = val["CompanyImage"] as! String

                    let company = Company(imageURL: Image, companyName: Name, companyID: companyID)
                    self.companies.append(company)
                    self.tableView.reloadData()
                }
            }
        }


    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toProductList") {
            let secondVC = segue.destination as! ProductViewController
            secondVC.company = companySelected
            secondVC.categoryType = category
        }
    }
    
    
    
    
}

extension DisplayedCompanyViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyCell", for: indexPath) as! CompanyCell
        
        cell.companyName.text = companies[indexPath.row].companyName
        let imageURL = companies[indexPath.row].imageURL
        cell.companyImage?.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "Companies"), options: .highPriority, progress: nil, completed: { (downloadImage, downloadException, cacheType, downloadURL) in
            
            if let downloadException = downloadException {
                print("Error downloading an image: \(downloadException.localizedDescription)")
            } else {
                print("Succesfully donwloaded image")
            }
        })
        
        
        return cell
    }
    
    
}


extension DisplayedCompanyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        companySelected = companies[indexPath.row].companyID
        print(companySelected)
        performSegue(withIdentifier: "toProductList", sender: self)
    }
}



extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
