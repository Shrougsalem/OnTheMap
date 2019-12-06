//
//  UdacityAPI.swift
//  On The Map
//
//  Created by Shroog Salem on 27/11/2019.
//  Copyright © 2019 Shroug Salem. All rights reserved.
//

import Foundation
import MapKit

class UdacityAPI {
    
    //MARK: - Create Session
    static func postSession (email: String, password: String, completion: @escaping (String?) -> ()) {
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let statusCode = (response as? HTTPURLResponse)?.statusCode { //Request sent succesfully
                if statusCode >= 200 && statusCode < 300 { //Response is ok
                     if error != nil {
                        completion(error?.localizedDescription)
                        return
                    }
                    
                    let range = 5..<data!.count
                    let newData = data?.subdata(in: range) /* subset response data! */
                    print(String(data: newData!, encoding: .utf8)!)
                    
                    let result = try! JSONSerialization.jsonObject(with: newData!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
                    if let resultError = result["error"] as? String {
                        completion(resultError)
                        return
                    }
                    
                    let dict = result ["account"] as! [String: Any]
                    let uniqueKey = dict ["key"] as! String
                    UserInformation.uniqueKey = uniqueKey
                    completion(nil)
                    } else { //Error in given login credintials
                        completion("Provided login credintials didn't match our records")
                    }
                } else { //Request failed to be sent
                    completion("Check your internet connection.")
                }
            }
            task.resume()
    }
    
    //MARK: - Delete Session
    static func deleteSession (completion: @escaping (Error?) -> () ) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }
    
    //MARK: Post Student Location
    static func postStudentLocation(mapString: String, mediaURL: String, locationCoordinates: CLLocationCoordinate2D, completion: @escaping (Error?) -> ()){
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"uniqueKey\": \"\(UserInformation.uniqueKey)\", \"firstName\": \"\(UserInformation.firstName)\", \"lastName\": \"\(UserInformation.lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(locationCoordinates.latitude), \"longitude\": \(locationCoordinates.longitude)}".data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {// Handle error…
                completion(error)
                return
            }
            print(String(data: data!, encoding: .utf8)!)
            completion(nil)
        }
        task.resume()
    }
    
    //MARK: Get Students Locations
    static func getStudentLocations(completion: @escaping ([StudentLocation]?, String?)->()){
       
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100&order=-updatedAt")!)
        request.httpMethod = "GET"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error != nil {
                completion (nil, error?.localizedDescription)
                return
            }
            
            let jsonDict = try! JSONSerialization.jsonObject(with: data!, options:[]) as! [String:Any]
            
            guard let outcomes = jsonDict ["results"] as? [[String:Any]] else {return}
            let outcomesData = try! JSONSerialization.data(withJSONObject: outcomes, options: .prettyPrinted)
            let studentsLocations = try! JSONDecoder().decode([StudentLocation].self, from: outcomesData)
            StudentsLocations.sharedObject.studentsLocations = studentsLocations
            completion(studentsLocations, nil)
        }
        task.resume()
    }
    
    
    //MARK: - Get Public User Data
    static func getPublicUserData(completion: @escaping (String?)->()){
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/\(UserInformation.uniqueKey)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                completion(error?.localizedDescription)
                return
            }
            let subdata = data![5..<data!.count]
            guard let dictionary = try? JSONSerialization.jsonObject(with: subdata, options: []) as? [String : Any] else {
                completion("Result is nil or could not be cast to [String:Any]")
                return
            }
            UserInformation.firstName = dictionary["first_name"] as? String ?? ""
            UserInformation.lastName = dictionary["last_name"] as? String ?? ""
            completion(nil)
            }
            task.resume()
    }
   
   
}
