//
//  StudentLocation.swift
//  On The Map
//
//  Created by Shroog Salem on 26/11/2019.
//  Copyright © 2019 Shroug Salem. All rights reserved.
//

import Foundation
struct StudentLocation : Codable {
    let objectId: String?
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaURL: String?
    let latitude: Double?
    let longitude: Double?
    let createdAt: String?
    let updatedAt: String?
    //let ACL: String
}
