//
//  EventListSample.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/14/24.
//

import Foundation


struct EventResponse: Codable {
    let isSuccess: Bool
    let statusCode: Int
    let message: String
    let result: [Event]
}

struct Event: Codable, Identifiable {
    let id: Int
    let what: String
    let eventWhere: String
    let withWho: String
    let EventYear: Int
    let EventMonth: Int
    let EventDate: Int
    let startTime: String?
    let endTime: String?
    let imageUrlList: [String]
    let categories: [Category]
    
    enum CodingKeys: String, CodingKey {
        case id = "eventId"
        case what
        case eventWhere
        case withWho
        case EventYear
        case EventMonth
        case EventDate
        case startTime
        case endTime
        case imageUrlList
        case categories
    }
}

struct Category: Codable {
    let id: Int
    let name: String
    let color: String
    
    enum CodingKeys: String, CodingKey {
        case id = "categoryId"
        case name = "categoryName"
        case color = "categoryColor"
    }
}


class EventListViewModel: ObservableObject {
    @Published var eventListData: EventResponse?

    init() {
        self.loadEventListData()
    }

    func loadEventListData() {
        let jsonData = """
        {
            "isSuccess": true,
            "statusCode": 1000,
            "message": "이벤트 조회에 성공하였습니다.",
            "result": [
                {
                    "eventId": 3,
                    "what": "초코라떼를 먹었다.",
                    "eventWhere": "잠실에서",
                    "withWho": "황수연이랑",
                    "EventYear": 2023,
                    "EventMonth": 12,
                    "EventDate": 24,
                    "startTime": null,
                    "endTime": null,
                    "imageUrlList": [
                        "https://picsum.photos/200/300",
                        "https://picsum.photos/200/300",
                        "https://picsum.photos/200/300"
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
                },
                {
                    "eventId": 58,
                    "what": "1/30 수정 테스트",
                    "eventWhere": "잠실에서",
                    "withWho": "황수연이랑",
                    "EventYear": 2023,
                    "EventMonth": 12,
                    "EventDate": 24,
                    "startTime": "13:00",
                    "endTime": "18:00",
                    "imageUrlList": [
                        "https://picsum.photos/200/300"
                    ],
                    "categories": [
                        {
                            "categoryId": 4,
                            "categoryName": "동기들",
                            "categoryColor": "#a3ffb6"
                        }
                    ]
                },
                {
                    "eventId": 60,
                    "what": "1/30 수정 테스트",
                    "eventWhere": "잠실에서",
                    "withWho": "황수연이랑",
                    "EventYear": 2023,
                    "EventMonth": 12,
                    "EventDate": 24,
                    "startTime": "13:00",
                    "endTime": "18:00",
                    "imageUrlList": [
                        "https://picsum.photos/200/300"
                    ],
                    "categories": [
                        {
                            "categoryId": 4,
                            "categoryName": "동기들",
                            "categoryColor": "#a3ffb6"
                        }
                    ]
                },
                {
                    "eventId": 61,
                    "what": "1/30 수정 테스트",
                    "eventWhere": "잠실에서",
                    "withWho": "황수연이랑",
                    "EventYear": 2023,
                    "EventMonth": 12,
                    "EventDate": 24,
                    "startTime": "13:00",
                    "endTime": "18:00",
                    "imageUrlList": [
                        "https://picsum.photos/200/300"
                    ],
                    "categories": [
                        {
                            "categoryId": 4,
                            "categoryName": "동기들",
                            "categoryColor": "#a3ffb6"
                        }
                    ]
                },
                {
                    "eventId": 65,
                    "what": "1/30 수정 테스트",
                    "eventWhere": "잠실에서",
                    "withWho": "황수연이랑",
                    "EventYear": 2023,
                    "EventMonth": 12,
                    "EventDate": 24,
                    "startTime": "13:00",
                    "endTime": "18:00",
                    "imageUrlList": [
                        "https://picsum.photos/200/300"
                    ],
                    "categories": [
                        {
                            "categoryId": 4,
                            "categoryName": "동기들",
                            "categoryColor": "#a3ffb6"
                        }
                    ]
                }
            ]
        }
        """.data(using: .utf8)!

        do {
            let decodedData = try JSONDecoder().decode(EventResponse.self, from: jsonData)
            self.eventListData = decodedData
        } catch {
            print("이벤트 리스트 조회 Decode 실패: \(error)")
        }
    }
}
