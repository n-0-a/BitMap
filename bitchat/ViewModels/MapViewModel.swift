//
//  MapViewModel.swift
//  bitchat
//
//  Created by Gemini on 10/7/25.
//

import Foundation
import Combine

class MapViewModel: ObservableObject {
    static let shared = MapViewModel()

    @Published var events: [MapEvent] = []
    
    var createdEventIDs = Set<UUID>()
    var confirmedEventIDs = Set<UUID>()
    
    private var timer: Timer?

    private init() { // Make init private for singleton
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.pruneExpiredEvents()
        }
    }

    func addEvent(_ event: MapEvent, createdLocally: Bool) {
        events.append(event)
        if createdLocally {
            createdEventIDs.insert(event.id)
        }
    }

    func confirmEvent(eventID: UUID) {
        if let index = events.firstIndex(where: { $0.id == eventID }) {
            events[index].confirmations += 1
            events[index].expiresAt = Date().addingTimeInterval(300) // Add 5 minutes
            confirmedEventIDs.insert(eventID)
        }
    }
    
    func handleIncomingMapEvent(_ event: MapEvent) {
        // Prevent duplicates
        guard !events.contains(where: { $0.id == event.id }) else { return }
        addEvent(event, createdLocally: false)
    }
    
    func handleIncomingConfirmation(eventID: UUID) {
        if let index = events.firstIndex(where: { $0.id == eventID }) {
            events[index].confirmations += 1
            events[index].expiresAt = Date().addingTimeInterval(300) // Add 5 minutes
        }
    }

    private func pruneExpiredEvents() {
        let now = Date()
        DispatchQueue.main.async {
            self.events.removeAll { $0.expiresAt < now }
        }
    }
}