//
//  CreateEventView.swift
//  bitchat
//
//  Created by Gemini on 10/7/25.
//

import SwiftUI
import CoreLocation

struct CreateEventView: View {
    @Binding var isPresented: Bool
    var location: CLLocationCoordinate2D
    var onEventCreated: (MapEvent) -> Void

    @State private var description: String = ""
    @State private var selectedEmoji: String = "📍"
    
    let eventTypes = ["📍", "🔥", "⚠️", "🚓", "❤️"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Event Details")) {
                    TextField("Description", text: $description)
                    
                    Picker("Event Type", selection: $selectedEmoji) {
                        ForEach(eventTypes, id: \.self) { emoji in
                            Text(emoji).tag(emoji)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section {
                    Button("Create Event") {
                        let newEvent = MapEvent(
                            id: UUID(),
                            eventType: selectedEmoji,
                            description: description,
                            latitude: location.latitude,
                            longitude: location.longitude,
                            createdAt: Date(),
                            expiresAt: Date().addingTimeInterval(600), // 10 minutes
                            confirmations: 0
                        )
                        onEventCreated(newEvent)
                        isPresented = false
                    }
                }
            }
            .navigationTitle("New Map Event")
            .navigationBarItems(trailing: Button("Cancel") {
                isPresented = false
            })
        }
    }
}
