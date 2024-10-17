//
//  EventListResponseDTO.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/17/24.
//

import Foundation

struct EventListResponseDTO: Codable {
    let isSuccess: Bool
    let statusCode: Int
    let message: String
    let result: [EventResultData]
}

struct EventResultData: Codable {
    let eventId: Int64
    let title: String
    let what: String
    let eventWhere: String
    let withWho: String
    let EventYear: Int32
    let EventMonth: Int32
    let EventDate: Int32
    let eventImageUrlList: [String]
    let categories: [CategoryResultData]
}
