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
    case getEventDetail(userId: String, eventId: Int64)
}

extension EventAPI: BaseTargetType {
    var headerType: HeaderType {
        switch self {
        case .getEventList:
            return .accessTokenHeaderForJson
        case .getEventDetail:
            return .accessTokenHeaderForJson
        }
    }
    
    var path: String {
        switch self {
        case .getEventList(userId: let userId, _, _, _):
            return "/api/v2/events/\(userId)"
        case .getEventDetail(userId: let userId, eventId: let eventId):
            return "/api/v2/events/\(userId)/\(eventId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getEventList:
            return .get
        case .getEventDetail:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getEventList(_, year: let year, month: let month, day: let day):
            return .requestParameters(parameters: ["eventYear": year, "eventMonth" : month, "eventDate" : day],encoding: URLEncoding.queryString)
        case .getEventDetail:
            return .requestPlain
        }
    }
}
