//
//  ThumbnailResponseDTO.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/4/24.
//

import Foundation

struct ThumbnailListResponseDTO : Codable {
    let isSuccess: Bool
    let statusCode: Int
    let message: String
    let result: [ThumbnailResultData]
}

struct ThumbnailResultData: Codable {
    let thumbnailId: Int64
    let eventYear: Int32
    let eventMonth: Int32
    let eventDate: Int32
    let thumbnailUrl: String
}

struct ThumbnailResponseDTO: Codable {
    let isSuccess: Bool
    let statusCode: Int
    let message: String
    let result: ThumbnailResultData
}

struct ThumbnailDeleteResponseDTO: Codable {
    let isSuccess: Bool
    let statusCode: Int
    let message: String
    let result: String?
}
