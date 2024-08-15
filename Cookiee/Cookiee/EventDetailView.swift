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
    @State var date: Date

    var body: some View {
        VStack {
            VStack {
                if let eventData = eventViewModel.eventData {
                    HStack (alignment: .bottom) {
                        Text("\(date, formatter: Self.dateFormatter)")
                            .font(.Head1_B)
                        Spacer()
                        HStack {
                            Button {
                                // action
                            } label: {
                                Image("EditIcon")
                            }
                            Button {
                                // action
                            } label: {
                                Image("TrashIcon")
                            }
                            
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                
                    Text("Event: \(eventData.result.what)")
                    Text("Location: \(eventData.result.eventWhere)")
                    
                } else {
                    Text("Loading...")
                }
            }
            Spacer()
        }.padding()
        
        .onAppear() {
            eventViewModel.loadEventData()
        }
    }
}

#Preview {
    EventDetailView(eventId: "58", date: Date.now)
}


extension EventDetailView {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }()
}


