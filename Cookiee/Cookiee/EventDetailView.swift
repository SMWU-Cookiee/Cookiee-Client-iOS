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
                    
                    HStack {
                        // 사진
                        ScrollView {
                            Image("testimage")
                                .resizable()
                                .scaledToFill()
                                .frame(width: .infinity, height: 265)
                                .clipped()

                        }
                    }
                    
                    VStack {
                        Text(eventData.result.title)
                            .font(.Body0_SB)
                        HStack {
                            ForEach(eventData.result.categories, id: \.categoryId) { category in
                                CategoryLabel(name: category.categoryName, color: category.categoryColor)
                                    .padding(.horizontal, 1)
                            }
                        }

                    }
                    
                    ScrollView {
                        VStack (alignment: .leading) {
                            EventInfoDetailView(title: "장소", decription: eventData.result.eventWhere)
                            EventInfoDetailView(title: "내용", decription: eventData.result.what)
                            EventInfoDetailView(title: "함께한 사람", decription: eventData.result.withWho)
                        }
                        

                    }
 
                } else {
                    Spacer()
                    ProgressView()
                    Spacer()
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

struct EventInfoDetailView: View {
    let title: String
    let decription: String

    var body: some View {
        VStack (alignment: .leading) {
            HStack{
                Image("CookieeIcon_fill")
                Text(title)
                    .font(.Body1_R)
                    .foregroundStyle(Color.Brown01)
            }
            
            HStack {
                Text(decription)
                    .font(.Body1_R)
                    .padding(10)
                    .background(Color.Beige)
                    .cornerRadius(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

