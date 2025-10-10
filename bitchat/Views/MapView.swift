//
//  MapView.swift
//  bitchat
//
//  Created by Gemini on 10/7/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var chatViewModel: ChatViewModel
    @StateObject private var mapViewModel = MapViewModel.shared
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var showCreateEventSheet = false
    @State private var selectedEvent: MapEvent?

    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, annotationItems: mapViewModel.events) { event in
                MapAnnotation(coordinate: event.coordinate) {
                    Button(action: {
                        selectedEvent = event
                    }) {
                        Text(event.eventType)
                            .font(.largeTitle)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        showCreateEventSheet = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.blue)
                            .shadow(radius: 10)
                    }
                    .padding()
                }
            }
        }
        .sheet(isPresented: $showCreateEventSheet) {
            CreateEventView(
                isPresented: $showCreateEventSheet,
                location: region.center
            ) { newEvent in
                mapViewModel.addEvent(newEvent, createdLocally: true)
                chatViewModel.sendMapEvent(newEvent)
            }
        }
        .sheet(item: $selectedEvent) { event in
            if let index = mapViewModel.events.firstIndex(where: { $0.id == event.id }) {
                EventDetailView(event: $mapViewModel.events[index], onConfirm: { confirmedEvent in
                    mapViewModel.confirmEvent(eventID: confirmedEvent.id)
                    chatViewModel.sendMapEventConfirmation(for: confirmedEvent.id)
                }, onDismiss: {
                    selectedEvent = nil
                })
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .environmentObject(ChatViewModel(keychain: PreviewKeychainManager(), identityManager: SecureIdentityStateManager(PreviewKeychainManager())))
    }
}
