//
//  ThunbnailRequestDTO.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/15/24.
//

import Foundation

struct ThumbnailRequestDTO : Codable {
    let thumbnail: Data?
    let eventYear: Int
    let eventMonth: Int
    let eventDate: Int
}
