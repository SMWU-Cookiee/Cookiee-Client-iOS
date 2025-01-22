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
    @Published var isUpdateSuccess: Bool = false
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
    
    func addEvent(eventTitle: String, eventWhat: String, eventWhereText: String?, eventWherePlace: EventWherePlace?, withWho: String, year: Int32, month: Int32, date: Int32, categoryIds: [Int64], images: [PhotosPickerItem]) {
        
        var imagesData: [Data] = []
        
        Task {
            for image in images {
                if let imageData = try? await image.loadTransferable(type: Data.self) {
                    if let image = UIImage(data: imageData) {
                        imagesData.append(image.downscaleTOjpegData(maxBytes: 400_000))
                    } else {
                        print("❌ addEvent : UIImage 변환 실패")
                    }
                } else {
                    print("❌ addEvent : Failed to load image data")
                }
            }
            
            let request = EventRequestDTO(
                eventTitle: eventTitle,
                eventWhat: eventWhat,
                eventWhereText: eventWhereText,
                eventWherePlace: eventWherePlace,
                withWho: withWho,
                eventYear: year,
                eventMonth: month,
                eventDate: date,
                categoryIds: categoryIds,
                images: imagesData
            )
            
            service.postEvent(requestBody: request) { result in
                self.isAddSuccess = false
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
    
    func updateEvent(eventId: Int64, eventTitle: String, eventWhat: String, eventWhereText: String?, eventWherePlace: EventWherePlace?, withWho: String, year: Int32, month: Int32, date: Int32, categoryIds: [Int64], images: [Data]) {
        
        Task {

            let request = EventRequestDTO(
                eventTitle: eventTitle,
                eventWhat: eventWhat,
                eventWhereText: eventWhereText,
                eventWherePlace: eventWherePlace,
                withWho: withWho,
                eventYear: year,
                eventMonth: month,
                eventDate: date,
                categoryIds: categoryIds,
                images: images
            )
            
            service.putEvent(eventId: eventId, requestBody: request) { result in
                self.isUpdateSuccess = false
                switch result {
                case .success(let response):
                    self.isUpdateSuccess = true
                    print("✅ updateEvent 성공\n", response)
                case .failure(let error):
                    self.isUpdateSuccess = false
                    print("❌ updateEvent 실패\n", error)
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
