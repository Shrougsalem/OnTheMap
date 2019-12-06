//
//  StudentLocationsModel.swift
//  On The Map
//
//  Created by Shroog Salem on 30/11/2019.
//  Copyright © 2019 Shroug Salem. All rights reserved.
//

import Foundation
class StudentsLocations {
    static var sharedObject = StudentsLocations()
    var studentsLocations: [StudentLocation]?
}
