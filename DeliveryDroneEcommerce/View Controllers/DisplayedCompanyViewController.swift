//
//  DisplayedCompanyViewController.swift
//  DeliveryDroneEcommerce
//
//  Created by Michael Peng on 4/10/20.
//  Copyright © 2020 Michael Peng. All rights reserved.
//

import UIKit
import Firebase

class DisplayedCompanyViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var companies: [CompanyCell] = [
       ]
    
    var category: String = "" //Will get filled out during segue
    var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        ref = Database.database().reference()
        
        tableView.register(UINib(nibName: "CompanyCell", bundle: nil), forCellReuseIdentifier: "CompanyCell")
    

        // Do any additional setup after loading the view.
    }
    
    func retrieveCompanies () {
        let categoryDB = ref.child("Storage").child(category)
        
        categoryDB.observe(.childAdded) { (snapshot) in
            print(snapshot)
        }
    }
    

//    func retrieveMessages() {
//
//            self.ref.child("UserInfo").child(Auth.auth().currentUser!.uid).child("current").observeSingleEvent(of: .value) { (snapshot) in
//
//                guard let value = snapshot.value as? NSDictionary else {
//                    print("No Data!!!")
//                    return
//                }
//                let identity = value["ID"] as! String
//
//                self.classRoomCode = identity
//                let messageDB = self.ref.child("Classrooms").child(identity).child("Messages")
//
//                messageDB.observe(.childChanged) { (snapshot) in
//
//                    print("something was changed in messageDB")
//                    let rowChanged = snapshot.value as! Int
//                    self.messages[rowChanged].correct = true
//                    self.tableView.reloadData()
//                }
//
//                messageDB.observe(.childAdded) { (snapshot) in
//
//                    print("something was added in messageDB")
//                    if (!snapshot.hasChildren()) {
//                        return
//                    }
//                    let snapshotValue = snapshot.value as! Dictionary<String,Any>
//                    let Text = snapshotValue["MessageBody"]!
//                    let Sender = snapshotValue["Sender"]!
//                    let SenderID = snapshotValue["SenderID"]!
//                    let messageT : String = snapshotValue["messageType"]! as! String
//                    let messageIndex : Int = snapshotValue["Index"] as! Int
//                    let id : Int = snapshotValue["ID"] as! Int
//                    let correct1 : Bool = snapshotValue["correct"] as! Bool
//                    //                let unique : String = snapshotValue["childID"] as! String
//
//                    let message = Message(sender: Sender as! String, body: Text as! String, senderID: SenderID as! String, messageType: messageT as! String, ID: id, correct: correct1)
//
//                    if (messageT == "Answer") {
//                        self.messages.insert(message, at: messageIndex)
//                    }
//                    else {
//                        self.messages.append(message)
//                    }
//
//                    self.tableView.reloadData()
//                    var indexPath : IndexPath
//                    if (self.questionRow == 0) {
//                        indexPath = IndexPath(row: self.messages.count - 1, section: 0)
//    //                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
//                    } else {
//                        indexPath = IndexPath(row: self.questionRow, section: 0)
//    //                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
//                    }
//
//                    if (messageT != "Answer") {
//                        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
//                    }
//
//                }
//            }
//
//        }

}

extension DisplayedCompanyViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyCell", for: indexPath) as! CompanyCell
        return cell
    }
    
    
}
