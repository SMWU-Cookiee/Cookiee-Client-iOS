//
//  ThumbnailViewModel.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/15/24.
//

import Foundation
import UIKit

class ThumbnailViewModel : ObservableObject {
    @Published var thumbnail: String = ""
    
    let service = ThumbnailService()
    
    func registerThumbnail(year: Int32, month: Int32, day: Int32, thumbnailImage: UIImage) {
        let imageData = thumbnailImage.jpegData(compressionQuality: 1.0)
        
        let request = ThumbnailRequestDTO(
            thumbnail: imageData,
            eventYear: year,
            eventMonth: month,
            eventDate: day
        )
        
        service.postThumbnail(requestBody: request) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.thumbnail = response.result.thumbnailUrl
                    print("✅ registerThumbnail 성공\n")
                }
            case .failure(let error):
                print("❌ registerThumbnail 실패\n", error)
            }
        }
    }

    
    func loadThumbnilByDate(year: Int32, month: Int32, day: Int32) {
        service.getThumbnailByDate(year: year, month: month, day: day) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.thumbnail = response.result.thumbnailUrl
                    print("✅ loadThumbnilByDate 성공\n")
                }
            case .failure(let error):
                print("❌ loadThumbnilByDate 실패\n", error)
            }
        }
    }
    
    func removeThumbnail(thumbnailId: String) {
        service.deleteThumbnail(thumbnailId: thumbnailId) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.thumbnail = ""
                    print("✅ removeThumbnail 성공", response)
               }
            case .failure(let error):
                print("❌ removeThumbnail 실패:", error)
            }
        }
    }
    
    func updateThumbnail(thumbnailId: String, newThumbnail: UIImage) {
        let imageData = newThumbnail.jpegData(compressionQuality: 1.0)

        if imageData != nil {
            service.putThumbnail(thumbnailId: thumbnailId, newThumbnail: imageData!){ result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self.thumbnail = response.result.thumbnailUrl
                        print("✅ updateThumbnail 성공", response)
                   }
                case .failure(let error):
                    print("❌ updateThumbnail 실패:", error)
                }
            }
        }
    }
}
