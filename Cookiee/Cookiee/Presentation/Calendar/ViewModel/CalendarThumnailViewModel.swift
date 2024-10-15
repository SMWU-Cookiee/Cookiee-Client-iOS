//
//  CalendarThumnailViewModel.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/15/24.
//

import Foundation

class CalendarThumnailViewModel : ObservableObject {
    @Published var thumbnailList: [ThumbnailResultData] = []
    
    let service = ThumbnailService()
    
    func loadThumbnailList() {
        service.getThumbnailList() { result in
            switch result {
            case .success(let response):
                self.thumbnailList = response.result
                print("✅ loadThumbnailList 성공\n", response.result)
            case .failure(let error):
                print("❌ loadThumbnailList 실패\n", error)
            }
        }
    }
}
