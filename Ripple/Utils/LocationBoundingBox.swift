//
//  LocationBoundingBox.swift
//  Ripple
//
//  Created by Dlovan Sharif on 2024-12-29.
//

import Foundation

func calculateBoundingBox(center: Coordinate, zoneSize: ZoneSize) -> (latStart: Double, latEnd: Double, longStart: Double, longEnd: Double) {
    let distanceInMeters: Double
    switch zoneSize {
    case .small:
        distanceInMeters = 3000.0
    case .medium:
        distanceInMeters = 5000.0
    case .large:
        distanceInMeters = 10000.0
    case .extraLarge:
        distanceInMeters = 15000.0
    }
    
    let latDegreeLength = 111_000.0
    let latChange = distanceInMeters / latDegreeLength
    
    let lonDegreeLength = 111_000.0 * cos(center.latitude * .pi / 180.0)
    let lonChange = distanceInMeters / lonDegreeLength
    
    let latStart = center.latitude - latChange
    let latEnd = center.latitude + latChange
    let longStart = center.longitude - lonChange
    let longEnd = center.longitude + lonChange
    
    return (latStart, latEnd, longStart, longEnd)
}
