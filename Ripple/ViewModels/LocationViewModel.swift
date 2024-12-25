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
    @Published var localizedChats: [Chat] = []
    @Published var localizedEvents: [Event] = []
    @Published var isLoading: Bool = true
    
    private var locationRepository: LocationRepository = LocationRepository()
    private var queryTimer: Timer?
    private var manager = CLLocationManager()
    
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
        @unknown default:
            locationAuthorized = .notDetermined
        }
    }
    
    func getDataByLocation(locationMode: LocationMode) async {
        switch locationMode {
        case .events:
            if let location = self.lastKnownLocation {
                let events = await self.locationRepository.getEvents(location: location)
                await MainActor.run {
                    self.localizedEvents = events
                }
            }
        case .chats:
            if let location = self.lastKnownLocation {
                let chats =  await self.locationRepository.getChats(location: location)
                await MainActor.run {
                    self.localizedChats = chats
                }
            }
        }
    }
    
    func startPeriodicLocationTask(locationMode: LocationMode) {
        queryTimer?.invalidate()
        queryTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.manager.requestLocation()
            Task { @MainActor in
                await self?.getDataByLocation(locationMode: locationMode)
                self?.isLoading = false
            }
        }
        queryTimer?.fire()
    }

    
    func stopPeriodicLocationTask () {
        queryTimer?.invalidate()
        queryTimer = nil
    }
        
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
    }
        
    deinit {
        self.stopPeriodicLocationTask()
    }
}
