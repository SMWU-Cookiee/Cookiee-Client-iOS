//
//  ThumbnailViewModel.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/15/24.
//

import Foundation
import UIKit


struct ThumbnailData: Codable {
    let thumbnailId: Int64
    let thumbnailUrl: String
}

class ThumbnailViewModel : ObservableObject {
    @Published var thumbnailData: ThumbnailData?
    @Published var isLoading: Bool = false
    
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
            self.isLoading = true
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.thumbnailData = ThumbnailData(thumbnailId: response.result.thumbnailId, thumbnailUrl: response.result.thumbnailUrl)
                    self.loadThumbnilByDate(year: year, month: month, day: day)
                    self.isLoading = false
                    print("✅ registerThumbnail 성공\n")
                }
            case .failure(let error):
                print("❌ registerThumbnail 실패\n", error)
            }
        }
    }

    
    func loadThumbnilByDate(year: Int32, month: Int32, day: Int32) {
        service.getThumbnailByDate(year: year, month: month, day: day) { result in
            self.isLoading = true
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.thumbnailData = ThumbnailData(thumbnailId: response.result.thumbnailId, thumbnailUrl: response.result.thumbnailUrl)
                    self.isLoading = false
                    print("✅ loadThumbnilByDate 성공\n")
                }
            case .failure(let error):
                self.isLoading = false
                print("❌ loadThumbnilByDate 실패\n", error)
            }
        }
    }
    
    func removeThumbnail(thumbnailId: String, year: Int32, month: Int32, day: Int32) {
        service.deleteThumbnail(thumbnailId: thumbnailId) { result in
            self.isLoading = true
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.thumbnailData = nil
                    self.loadThumbnilByDate(year: year, month: month, day: day)
                    self.isLoading = false
                    print("✅ removeThumbnail 성공", response)
               }
            case .failure(let error):
                self.isLoading = false
                print("❌ removeThumbnail 실패:", error)
            }
        }
    }
    
    func updateThumbnail(thumbnailId: String, newThumbnail: UIImage, year: Int32, month: Int32, day: Int32) {
        let imageData = newThumbnail.jpegData(compressionQuality: 1.0)

        if imageData != nil {
            self.isLoading = true
            service.putThumbnail(thumbnailId: thumbnailId, newThumbnail: imageData!){ result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self.thumbnailData = ThumbnailData(thumbnailId: response.result.thumbnailId, thumbnailUrl: response.result.thumbnailUrl)
                        self.loadThumbnilByDate(year: year, month: month, day: day)
                        self.isLoading = false
                        print("✅ updateThumbnail 성공", response)
                   }
                case .failure(let error):
                    self.isLoading = false
                    print("❌ updateThumbnail 실패:", error)
                }
            }
        }
    }
}
