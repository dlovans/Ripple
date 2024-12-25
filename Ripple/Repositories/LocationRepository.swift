//
//  LocationRepository.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-12-25.
//

import Foundation
import CoreLocation

class LocationRepository {
    
    func getChats(location: CLLocationCoordinate2D) async -> [Chat] {
        return [Chat(id: "123", chatName: "Test Chat", connections: 10)]
    }
    
    func getEvents(location: CLLocationCoordinate2D) async -> [Event] {
        return [Event(id: "123", category: "Food", title: "Teaparty", description: "Let's have a tea party", imageURL: nil)]
    }
}
