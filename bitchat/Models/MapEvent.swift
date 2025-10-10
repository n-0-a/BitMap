//
//  MapEvent.swift
//  bitchat
//
//  Created by Gemini on 10/7/25.
//

import Foundation
import CoreLocation

struct MapEvent: Codable, Identifiable, Equatable {
    let id: UUID
    let eventType: String // Emoji
    let description: String
    let latitude: Double
    let longitude: Double
    let createdAt: Date
    var expiresAt: Date
    var confirmations: Int

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    static func == (lhs: MapEvent, rhs: MapEvent) -> Bool {
        lhs.id == rhs.id
    }
}
