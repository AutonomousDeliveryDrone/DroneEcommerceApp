//
//  CustomerOrderCell.swift
//  
//
//  Created by Gavin Wong on 4/12/20.
//

import UIKit

class CustomerOrderCell: UITableViewCell {

    @IBOutlet var productImage: UIImageView!
    @IBOutlet var productName: UILabel!
    @IBOutlet var cost: UILabel!
    @IBOutlet var company: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
