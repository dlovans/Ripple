//
//  LocationManager.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-12-23.
//

import Foundation
import CoreLocation

class LocationViewModel: NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var locationAuthorized: CLAuthorizationStatus = .notDetermined
    @Published var lastKnownLocation: CLLocationCoordinate2D?
    var manager = CLLocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
        self.locationAuthorized = manager.authorizationStatus
    }
    
    func checkLocationAuthorization() {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            locationAuthorized = manager.authorizationStatus
        case .authorizedWhenInUse, .authorizedAlways:
            locationAuthorized = manager.authorizationStatus
            startUpdatingLocation()
        @unknown default:
            locationAuthorized = .notDetermined
        }
    }
    
    func startUpdatingLocation() {
        manager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
    }
        
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
    }
}
