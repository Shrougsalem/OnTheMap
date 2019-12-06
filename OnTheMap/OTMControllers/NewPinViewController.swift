//
//  ViewController.swift
//  On The Map
//
//  Created by Shroog Salem on 23/11/2019.
//  Copyright © 2019 Shroug Salem. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class NewPinViewController: UIViewController, UITextFieldDelegate {
   
    //MARK: - Properties
    var locationCoordinates: CLLocationCoordinate2D!
    var locationName: String!
    var mediaURL: String!
    //MARK: - Outlets
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var URLTextField: UITextField!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //for keyboard adjustments
        locationTextField.delegate = self
        URLTextField.delegate = self
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    //MARK: - Actions
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocation(_ sender: Any) {
        //to verify
        guard let url = URLTextField.text, let locationName = locationTextField.text, URLTextField.text!.lowercased().hasPrefix("https://") || URLTextField.text!.lowercased().hasPrefix("http://")  else {
            self.alert(title: "Warning: Missing or Invalid Information", message: "You must enter the location name and a valid link that includes http(s)://")
            return
        }
        self.showSpinner()
        setLocationCoordinates(location: locationName) { (locationCoordinates, error) in
            self.removeSpinner()
            if error != nil {
                self.alert(title: "Error", message: "Try Another Place.")
                return
            }
            self.locationCoordinates = locationCoordinates
            self.locationName = locationName
            self.mediaURL = url
            self.performSegue(withIdentifier: "confirmPinLocation", sender: self)
        }
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "confirmPinLocation" {
            let viewController = segue.destination as! SubmitPinViewController
            viewController.locationName = self.locationName
            viewController.locationCoordinates = self.locationCoordinates
            print(locationCoordinates!)
            viewController.mediaURL = self.mediaURL
        }
    }
    
    func setLocationCoordinates(location: String, completion: @escaping (_ locationCoordicates: CLLocationCoordinate2D?, _ error: Error?) -> ()) {
        //to get the location coordinates
        CLGeocoder().geocodeAddressString(location) { placemarks, error in completion(placemarks?.first?.location?.coordinate, error)
        }
    }
   
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

