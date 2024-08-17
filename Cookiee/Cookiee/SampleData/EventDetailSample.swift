//
//  EventDetailSample.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/15/24.
//

import SwiftUI

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

class EventViewModel: ObservableObject {
    @Published var eventData: EventData?
    
    init() {
        self.loadEventData()
    }
    
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

