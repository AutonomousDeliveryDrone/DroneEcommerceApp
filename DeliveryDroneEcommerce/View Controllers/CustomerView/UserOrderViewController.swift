//
//  UserOrderViewController.swift
//  DeliveryDroneEcommerce
//
//  Created by Michael Peng on 4/11/20.
//  Copyright © 2020 Michael Peng. All rights reserved.
//

import UIKit

class UserOrderViewController: UIViewController {

    
    var company : String = ""
    var categoryType : String = ""
    var name : String = ""
    var price : Int = 0
    var desc : String = ""
    var link : String = ""
    var index : Int = 0
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var productDesc: UITextView!
    @IBOutlet weak var productLink: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productName.text = name
        productPrice.text = String(price)
        productDesc.text = desc
        productLink.text = link
        
        

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
