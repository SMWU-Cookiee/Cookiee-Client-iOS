//
//  EventRequestDTO.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/26/24.
//

import Foundation

public struct EventRequestDTO: Codable {
    let eventTitle: String
    let eventWhat: String
    let eventWhere: String
    let withWho: String
    let eventYear: Int32
    let eventMonth: Int32
    let eventDate: Int32
    let categoryIds: [Int64]
    let images: [Data]
}
