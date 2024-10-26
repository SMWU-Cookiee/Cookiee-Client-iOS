//
//  EventViewModel.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/17/24.
//

import Foundation
import _PhotosUI_SwiftUI

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
    @Published var isAddSuccess: Bool = false
    @Published var isEditButtonTapped: Bool = false

    
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
    
    func addEvent(eventTitle: String, eventWhat: String, eventWhere: String, withWho: String, year: Int32, month: Int32, date: Int32, categoryIds: [Int64], images: [PhotosPickerItem]) {
        
        var imagesData: [Data] = []
        
        Task {
            for image in images {
                if let data = try? await image.loadTransferable(type: Data.self) {
                    imagesData.append(data)
                } else {
                    print("Failed to load image data.")
                }
            }
            
            let request = EventRequestDTO(
                eventTitle: eventTitle,
                eventWhat: eventWhat,
                eventWhere: eventWhere,
                withWho: withWho,
                eventYear: year,
                eventMonth: month,
                eventDate: date,
                categoryIds: categoryIds,
                images: imagesData
            )
            
            print(request.eventTitle)
            print(request.eventWhat)
            print(request.eventWhere)
            print(request.withWho)
            print(request.eventYear)
            print(request.eventMonth)
            print(request.eventDate)
            print(request.categoryIds.description)
            print(request.images.description)
            
            
            
            
            service.postEvent(requestBody: request) { result in
                switch result {
                case .success(let response):
                    self.isAddSuccess = true
                    print("✅ addEvent 성공\n", response)
                case .failure(let error):
                    self.isAddSuccess = false
                    print("❌ addEvent 실패\n", error)
                }
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
