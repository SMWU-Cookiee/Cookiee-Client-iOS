//
//  EventViewModel.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/17/24.
//

import Foundation

struct EventForCellDTO : Identifiable {
    let eventId: Int64
    let firstEventImage: String
    let firstCategory: CategoryResultData
    
    var id: Int64 {
        return eventId
    }
}

class EventViewModel : ObservableObject {
    @Published var eventListForCell: [EventForCellDTO] = []
    
    let service = EventService()
    
    func loadEventList(year: Int32, month: Int32, day: Int32) {
        service.getEventList(year: year, month: month, day: day){ result in
            switch result {
            case .success(let response):
                print("✅ loadEventList 성공\n", response)
                self.eventListForCell = []
                for event in response.result {
                    self.eventListForCell.append(
                        EventForCellDTO(
                            eventId: event.eventId,
                            firstEventImage: event.eventImageUrlList.first!,
                            firstCategory: event.categories.first!
                        )
                    )
                }
            case .failure(let error):
                print("❌ loadEventList 실패\n", error)
            }
        }
    }
}
