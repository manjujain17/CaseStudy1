//
//  MapViewController.swift
//  CaseStudy1
//
//  Created by adminn on 05/09/22.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // MARK: IBOutlet
    @IBOutlet weak var newMapView: MKMapView!
    
    // MARK: Variable
    // Instance of CLLocationManager
    var currLocManager: CLLocationManager!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        getUserLocation()
    }
    // MARK: Functions
    // To get User location
    func getUserLocation() {
        // Instance of CLLocatoinManager
        currLocManager = CLLocationManager()
        
        // Calling delegate
        currLocManager.delegate = self
        
        // Setting accuracy
        currLocManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Taking permission from user
        currLocManager.requestAlwaysAuthorization()
        
        // Checking if permission granted
        if CLLocationManager.locationServicesEnabled() {
            currLocManager.startUpdatingLocation()
        }
    }
    // Delegate Function
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Coordinates accessed from Locations array which stores the coordinates
        let userLocation: CLLocation = locations[0] as CLLocation
        
        // Providing the coordinates from the userLocation to locate
        let view = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        // To get broader view region of that location
        let region = MKCoordinateRegion(center: view, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        // Calling setRegion method in mapview kit and also passing region view
        
        newMapView.setRegion(region, animated: true)
        // Instance of MKPointAnnotation
        let pinpoint = MKPointAnnotation()
        
        // Passing Coordinates to newly created instance
        pinpoint.coordinate = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        // Title for Annotation
        getTitleValue { (annotationTitle) in
            pinpoint.title = annotationTitle
        }
        // Adding it to mapview
        newMapView.addAnnotation(pinpoint)
        func getTitleValue(handler: @escaping (String)-> Void) {
            let geocoder = CLGeocoder()
            let location = CLLocation(latitude: userLocation.coordinate.latitude , longitude: userLocation.coordinate.longitude)
            geocoder.reverseGeocodeLocation(location, completionHandler: {
                (placemarkArr, error) -> Void in
                var placemarks: CLPlacemark?
                placemarks = placemarkArr?[0]
                let annotationTitle = "\(placemarks?.subLocality ?? "")"
                handler(annotationTitle)
            })
        }
        
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
