//
//  EventDetailView.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/15/24.
//

import SwiftUI

struct EventDetailView: View {
    @StateObject private var eventViewModel = EventViewModel()
    @State var eventId: String

    var body: some View {
        VStack {
            Spacer()
            VStack {
                if let eventData = eventViewModel.eventData {
                    Text("Event: \(eventData.result.what)")
                    Text("Location: \(eventData.result.eventWhere)")
                    Text("Date: \(eventData.result.eventYear)-\(eventData.result.eventMonth)-\(eventData.result.eventDate)")
                } else {
                    Text("Loading...")
                }
            }
            Spacer()
        }
        
        .onAppear() {
            eventViewModel.loadEventData()
        }
    }
}

#Preview {
    EventDetailView(eventId: "58")
}


