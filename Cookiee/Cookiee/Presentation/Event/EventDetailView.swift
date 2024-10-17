//
//  EventDetailView.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/15/24.
//

import SwiftUI

struct EventDetailView: View {
    @StateObject private var eventViewModel = EventViewModel()
    @State var eventId: Int64
    @State var date: Date
    
    @State private var currentIndex: Int = 0
    @State private var imageList: [String] = []

    var body: some View {
        VStack {
            VStack {
                if let eventData = eventViewModel.eventDetail {
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
                        ImageCarouselView(index: $currentIndex, imageUrls: eventData.eventImageUrlList)
                            .frame(height: 365)
                    }
                    
                    VStack {
                        Text(eventData.title)
                            .font(.Body0_SB)
                        HStack {
                            ForEach(eventData.categories, id: \.categoryId) { category in
                                CategoryLabel(name: category.categoryName, color: category.categoryColor)
                                    .padding(.horizontal, 1)
                            }
                        }
                    }
                    .padding(.bottom, 3)
                    .padding(.top, 15)
                    
                    ScrollView {
                        VStack (alignment: .leading) {
                            EventInfoDetailView(title: "장소", decription: eventData.eventWhere)
                            EventInfoDetailView(title: "내용", decription: eventData.what)
                            EventInfoDetailView(title: "함께한 사람", decription: eventData.withWho)
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
            eventViewModel.loadEventDetail(eventId: eventId)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
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

#Preview {
    EventDetailView(eventId: 58, date: Date.now)
}
