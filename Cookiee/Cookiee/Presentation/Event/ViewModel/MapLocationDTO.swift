//
//  MapLocationDTO.swift
//  Cookiee
//
//  Created by minseo Kyung on 1/14/25.
//

import Foundation
import MapKit

struct MapLocationDTO: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
