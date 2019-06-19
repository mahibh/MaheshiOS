//
//  UserCC.swift
//  RewiseTest
//
//  Created by MAHESH MOHAN BHONDAVE on 18/06/19.
//  Copyright © 2019 Mahesh Bhondave. All rights reserved.
//

import UIKit
import CoreLocation

class UserCC: UITableViewCell {
    
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var countryLbl: UILabel!
    @IBOutlet var calculatedDistance: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
   
    
}
