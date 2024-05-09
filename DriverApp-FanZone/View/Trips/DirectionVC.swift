//
//  DirectionVC.swift
//  DriverApp-FanZone
//
//  Created by Mahmoud Mohamed Atrees on 09/05/2024.
//

import UIKit
import MapKit
import CoreLocation

class DirectionVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var endTripButton: UIButton!
    
    var destination: String?
    var latitude: Double?
    var longitude: Double?
    
    var destinationCoordinate: CLLocationCoordinate2D?
    var locationManager: CLLocationManager!
    var currentRoute: MKRoute?
    var lastUpdatedLocation: CLLocation?
    var hasZoomed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setLocationCoordinate()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.delegate = self
        mapView.userTrackingMode = .none
        // Calculate initial route
        if let userLocation = locationManager.location?.coordinate {
            calculateRoute(from: userLocation, to: destinationCoordinate!)
        }
    }
    
    @IBAction func endTripButtonPressed(_ sender: UIButton) {
    }
    
}

extension DirectionVC{
    func setLocationCoordinate(){
            guard let latitude = latitude, let longitude = longitude else {
                // Handle missing latitude or longitude
                return
            }
            
            destinationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            // Add destination annotation
            let destinationAnnotation = MKPointAnnotation()
            destinationAnnotation.coordinate = destinationCoordinate!
            destinationAnnotation.title = destination
            mapView.addAnnotation(destinationAnnotation)
            
        }
}

extension DirectionVC{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else { return }

        print("Latitude: \(userLocation.coordinate.latitude), Longitude: \(userLocation.coordinate.longitude)")
        
        mapView.annotations.forEach {
            if $0.title == "Current Location" {
                mapView.removeAnnotation($0)
            }
        }

        let userAnnotation = MKPointAnnotation()
        userAnnotation.coordinate = userLocation.coordinate
        userAnnotation.title = "Current Location"
        mapView.addAnnotation(userAnnotation)
        
        if !hasZoomed {
            let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
            mapView.setRegion(region, animated: true)
            hasZoomed = true
        }

        // Update route if user has moved significantly
        if let lastLocation = lastUpdatedLocation, userLocation.distance(from: lastLocation) > 5 {
            lastUpdatedLocation = userLocation
            if let currentRoute = currentRoute {
                mapView.removeOverlay(currentRoute.polyline)
            }
            calculateRoute(from: userLocation.coordinate, to: destinationCoordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0))
        } else {
            lastUpdatedLocation = userLocation
        }
    }
    
    func calculateRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        let sourcePlacemark = MKPlacemark(coordinate: source, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destination, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { [weak self] response, error in
            guard let self = self, let response = response else {
                if let error = error {
                    print("Error getting directions: \(error.localizedDescription)")
                }
                return
            }
            let route = response.routes[0]
            self.currentRoute = route
            if let route = self.currentRoute {
                print("Route calculated: \(route)")
            }
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "CustomAnnotation")
        annotationView.markerTintColor = annotation.title == "Current Location" ? .blue : .red
        annotationView.canShowCallout = true
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(red: 90/255, green: 178/255, blue: 255/255, alpha: 1.0)
        renderer.lineWidth = 8.0
        return renderer
    }
}


extension DirectionVC{
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
}
