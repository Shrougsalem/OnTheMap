//
//  SubmitPinViewController.swift
//  On The Map
//
//  Created by Shroog Salem on 05/12/2019.
//  Copyright © 2019 Shroug Salem. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SubmitPinViewController: UIViewController, MKMapViewDelegate{
    
    //MARK: - Properties & Outlets
    var locationName: String!
    var locationCoordinates: CLLocationCoordinate2D!
    var mediaURL: String!
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setMapPointAnnotation()
    }

    //MARK: - Actions
    @IBAction func finish(_ sender: Any) {
        
        UdacityAPI.postStudentLocation(mapString: locationName, mediaURL: mediaURL, locationCoordinates: locationCoordinates, completion: { error in
            if error != nil {
                self.alert(title: "Error", message: "Somthing Went Wrong. Try Again Later.")
                return
            }
            UserDefaults.standard.set(self.locationName, forKey: "studentLocation")
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        })
        
    }
    //MARK: - New Pin Annotation
    func setMapPointAnnotation() {
        // Here we create the annotation and set its coordiate, title, and subtitle properties then add it to the map
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinates!
        annotation.title = UserInformation.firstName + " " + UserInformation.lastName
        annotation.subtitle = mediaURL
        mapView.addAnnotation(annotation)
        // Setting current mapView's region to be centered at the pin's coordinate
        let region = MKCoordinateRegion(center: locationCoordinates!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    //MARK: - MKMap Delegate
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
