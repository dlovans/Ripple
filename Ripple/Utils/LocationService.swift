//
//  LocationManager.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-12-23.
//

import Foundation
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var locationAuthorized: CLAuthorizationStatus = .notDetermined
    @Published var lastKnownLocation: Coordinate?
    @Published var isLoading: Bool = true
        
    private var queryTimer: Timer?
    private var manager = CLLocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
        self.locationAuthorized = manager.authorizationStatus
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        print("locationservice created")
        manager.requestLocation()
    }
    
    func checkLocationAuthorization() {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            locationAuthorized = manager.authorizationStatus
        case .authorizedWhenInUse, .authorizedAlways:
            locationAuthorized = manager.authorizationStatus
        @unknown default:
            locationAuthorized = .notDetermined
        }
    }
    
    func startPeriodicLocationTask() {
        queryTimer?.invalidate()
        if isLoading { manager.requestLocation()}
        queryTimer = Timer.scheduledTimer(withTimeInterval: 90, repeats: true) { [weak self] _ in
            self?.manager.requestLocation()
        }
    }
        
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            if isLoading { isLoading = false }
            lastKnownLocation = Coordinate(latitude: lastLocation.coordinate.latitude,
                                           longitude: lastLocation.coordinate.longitude)
        }
    }
}
