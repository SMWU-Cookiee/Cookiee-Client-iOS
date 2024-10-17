//
//  EventDetailView.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/15/24.
//

import SwiftUI

struct EventDetailView: View {
    @StateObject private var eventViewModel = EventViewModelSample()
    @State var eventId: String
    @State var date: Date
    
    @State private var currentIndex: Int = 0
    @State private var imageList: [String] = []

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
                        ImageCarouselView(index: $currentIndex, imageUrls: eventData.result.imageUrlList)
                            .frame(height: 365)
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
                    .padding(.bottom, 3)
                    .padding(.top, 15)
                    
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
        .edgesIgnoringSafeArea(.bottom)
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



// 삭제 예정
struct EventCategory: Codable {
    let categoryId: Int
    let categoryName: String
    let categoryColor: String
}

struct EventResult: Codable {
    let eventId: Int
    let title: String
    let what: String
    let eventWhere: String
    let withWho: String
    let eventYear: Int
    let eventMonth: Int
    let eventDate: Int
    let imageUrlList: [String]
    let categories: [EventCategory]
}

struct EventData: Codable {
    let isSuccess: Bool
    let statusCode: Int
    let message: String
    let result: EventResult
}

class EventViewModelSample: ObservableObject {
    @Published var eventData: EventData?

    
    func loadEventData() {
        let jsonData = """
        {
            "isSuccess": true,
            "statusCode": 1000,
            "message": "이벤트 조회에 성공하였습니다.",
            "result": {
                "eventId": 58,
                "title": "도파민 넘치는 코타키나발루",
                "what": "매니매니 물고기가 있는 마무틱에서 스노클링도 하고, 사피에서는 스노클링 장비도 빠뜨리고.. 뭔 하루가 도파민만 나오다가 끝났니",
                "eventWhere": "코타키나발루 마무틱",
                "withWho": "작.변.시",
                "eventYear": 2024,
                "eventMonth": 8,
                "eventDate": 15,
                "imageUrlList": [
                    "https://picsum.photos/200/300",
                    "https://picsum.photos/300/300",
                    "https://picsum.photos/300/150"
                ],
                "categories": [
                    {
                        "categoryId": 3,
                        "categoryName": "여행",
                        "categoryColor": "#f75eff"
                    },
                    {
                        "categoryId": 4,
                        "categoryName": "동기들",
                        "categoryColor": "#a3ffb6"
                    }
                ]
            }
        }
        """.data(using: .utf8)!
        
        do {
            let decodedData = try JSONDecoder().decode(EventData.self, from: jsonData)
            self.eventData = decodedData
        } catch {
            print("이벤트 상세 정보 조회 Decode 실패: \(error)")
        }
    }
}
