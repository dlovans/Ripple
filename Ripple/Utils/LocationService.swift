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
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
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
    
    func requestLocation() {
        manager.requestLocation()
    }
    
    func startPeriodicLocationTask() {
        queryTimer?.invalidate()
        manager.requestLocation()
        queryTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in
            self?.manager.requestLocation()
        }
    }

    func stopPeriodicLocationTask () {
        queryTimer?.invalidate()
        queryTimer = nil
        self.manager.stopUpdatingLocation()
    }
        
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            lastKnownLocation = Coordinate(latitude: lastLocation.coordinate.latitude,
                                           longitude: lastLocation.coordinate.longitude)
        }
        isLoading = false
        print("Location updated.")
    }
        
    deinit {
        self.stopPeriodicLocationTask()
    }
}
