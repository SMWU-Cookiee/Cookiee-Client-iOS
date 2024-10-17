//
//  EventApi.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/17/24.
//

import Foundation
import Moya

enum EventAPI {
    case getEventList(userId: String, year: Int32, month: Int32, day: Int32)
}

extension EventAPI: BaseTargetType {
    var headerType: HeaderType {
        switch self {
        case .getEventList:
            return .accessTokenHeaderForJson
        }
    }
    
    var path: String {
        switch self {
        case .getEventList(userId: let userId, _, _, _):
            return "/api/v2/events/\(userId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getEventList:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getEventList(_, year: let year, month: let month, day: let day):
            return .requestParameters(parameters: ["eventYear": year, "eventMonth" : month, "eventDate" : day],encoding: URLEncoding.queryString)
        }
    }
}
