//
//  CookieeCollectionDetailResponseSTO.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/31/24.
//

import Foundation

struct CookieeCollectionDetailResponseDTO: Codable {
    let isSuccess: Bool
    let statusCode: Int
    let message: String
    let result: CookieeCollectionDetailResultData
}

struct CookieeCollectionDetailResultData: Codable {
    let category: CategoryResultData
    let eventImageList: [EventImageURLData]
}

struct EventImageURLData: Codable {
    let eventId: Int64
    let firstImageUrl: String
}
