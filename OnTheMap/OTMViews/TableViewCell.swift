//
//  TableViewCell.swift
//  On The Map
//
//  Created by Shroog Salem on 05/12/2019.
//  Copyright © 2019 Shroug Salem. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
   
    //MARK: IB Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var pinImageView: UIImageView!
    
    //MARK: Cell Configuration
    func cellConfig(studentInformation: StudentLocation) {
        pinImageView.image = UIImage(named:"icon_pin")//placeholder
        nameLabel.text =  (studentInformation.firstName ?? "No") + " " + (studentInformation.lastName ?? "Name")
        urlLabel.text = studentInformation.mediaURL
    }
    
}
