//
//  ThunbnailRequestDTO.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/15/24.
//

import Foundation

struct ThumbnailRequestDTO : Codable {
    let thumbnail: Data?
    let eventYear: Int32
    let eventMonth: Int32
    let eventDate: Int32
}
