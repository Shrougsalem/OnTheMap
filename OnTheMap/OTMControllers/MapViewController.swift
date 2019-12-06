//
//  MapViewController.swift
//  On The Map
//
//  Created by Shroog Salem on 03/12/2019.
//  Copyright © 2019 Shroug Salem. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: - Properties & Outlets
    var  locations: [StudentLocation]! {
        return StudentsLocations.sharedObject.studentsLocations
    }
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate=self
    }
    
    //MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
        if (locations == nil){
            refreshStudentsLocations(self)
        } else {
            DispatchQueue.main.async {
                self.updatePointAnnotations()
            }
        }
    }
    
    //MARK: - Actions
    @IBAction func LogOutTapped(_ sender: Any) {
        UdacityAPI.deleteSession { (error) in
            if error != nil {
                self.alert(title: "ERROR", message: error!.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                self.updatePointAnnotations()
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func refreshStudentsLocations(_ sender: Any) { UdacityAPI.getStudentLocations { (_, error) in
        if error != nil {
            self.alert(title: "Error", message: "Somthing went wrong!")
            return
        }
        DispatchQueue.main.async {
            self.updatePointAnnotations()
        }
        }
    }
    
    @IBAction func addPin(_ sender: Any) {
        if UserDefaults.standard.value(forKey: "studentLocation") != nil {
           self.overwriteAlert()
        }
        else {
            self.performSegue(withIdentifier: "addNewPin", sender: self)
        }
    }
    
    //MARK: - Pin Annotations
    func updatePointAnnotations(){
        // Here we create the annotation and set its coordiate, title, and subtitle properties and place it in the array to add it to the map
        var annotations = [MKPointAnnotation]()
        for studentLocation in locations {
            let lat = CLLocationDegrees(studentLocation.latitude!)
            let long = CLLocationDegrees(studentLocation.longitude!)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = studentLocation.firstName!
            let last = studentLocation.lastName!
            let mediaURL = studentLocation.mediaURL!
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(String(describing: first)) \(String(describing: last))"
            annotation.subtitle = mediaURL
            annotations.append(annotation)
            if !mapView.annotations.contains(where: {$0.title == annotation.title}){
                annotations.append(annotation)
            }
        }
        print("New point annotation: ", annotations.count-100)//debug
        mapView.addAnnotations(annotations)
        
    }
    // MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle!,
                let url = URL(string: toOpen), app.canOpenURL(url) {
                app.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    

}
