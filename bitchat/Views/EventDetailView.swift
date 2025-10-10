//
//  EventDetailView.swift
//  bitchat
//
//  Created by Gemini on 10/7/25.
//

import SwiftUI

struct EventDetailView: View {
    @Binding var event: MapEvent
    var onConfirm: (MapEvent) -> Void
    var onDismiss: () -> Void
    
    @StateObject private var mapViewModel = MapViewModel.shared
    @State private var timeRemaining: String = ""
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private var canConfirm: Bool {
        !mapViewModel.createdEventIDs.contains(event.id) && !mapViewModel.confirmedEventIDs.contains(event.id)
    }

    var body: some View {
        VStack(spacing: 20) {
            Text(event.eventType)
                .font(.system(size: 80))
            
            Text(event.description)
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            HStack {
                Label("\(event.confirmations)", systemImage: "hand.thumbsup.fill")
                Spacer()
                Label(timeRemaining, systemImage: "timer")
            }
            .font(.headline)
            .padding(.horizontal)

            Button(action: {
                onConfirm(event)
                onDismiss()
            }) {
                Label("Confirm Event", systemImage: "hand.thumbsup.fill")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(canConfirm ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .disabled(!canConfirm)
        }
        .onAppear(perform: updateTimeRemaining)
        .onReceive(timer) { _ in
            updateTimeRemaining()
        }
        .padding()
    }
    
    private func updateTimeRemaining() {
        let remaining = event.expiresAt.timeIntervalSinceNow
        if remaining > 0 {
            let minutes = Int(remaining) / 60
            let seconds = Int(remaining) % 60
            timeRemaining = String(format: "%02d:%02d", minutes, seconds)
        } else {
            timeRemaining = "Expired"
        }
    }
}
