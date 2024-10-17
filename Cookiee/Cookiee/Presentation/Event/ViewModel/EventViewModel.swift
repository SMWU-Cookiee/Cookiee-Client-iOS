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
    @Published var eventDetail: EventResultData?
    @Published var selectedEventId: Int64?
    @Published var isRemoveSuccess: Bool = false
    
    let service = EventService()
    
    func loadEventList(year: Int32, month: Int32, day: Int32) {
        service.getEventList(year: year, month: month, day: day){ result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
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
                    print("✅ loadEventList 성공\n", response)
                }
            case .failure(let error):
                print("❌ loadEventList 실패\n", error)
            }
        }
    }
    
    func loadEventDetail(eventId: Int64) {
        service.getEventDetail(eventId: eventId){ result in
            switch result {
            case .success(let response):
                self.eventDetail = response.result
                print("✅ loadEventDetail 성공\n", response)
            case .failure(let error):
                print("❌ loadEventDetail 실패\n", error)
            }
        }
    }
    
    func removeEvent(eventId: Int64) {
        service.deleteEvent(eventId: eventId){ result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                    self.isRemoveSuccess = true
                    print("✅ removeEvent 성공\n", response)
               }

            case .failure(let error):
                self.isRemoveSuccess = false
                print("❌ removeEvent 실패\n", error)
            }
        }
    }
}
