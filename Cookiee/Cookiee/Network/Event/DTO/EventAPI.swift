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
    case postEvent(userId: String, requestBody: EventRequestDTO)
    case putEvent(userId: String, eventId: Int64, requestBody: EventRequestDTO)
    case deleteEvet(userId: String, eventId: Int64)
}

extension EventAPI: BaseTargetType {
    var headerType: HeaderType {
        switch self {
        case .getEventList:
            return .accessTokenHeaderForJson
        case .getEventDetail:
            return .accessTokenHeaderForJson
        case .postEvent:
            return .accessTokenHeaderForJson
        case .putEvent:
            return .accessTokenHeaderForJson
        case .deleteEvet:
            return .accessTokenHeaderForJson
        }
    }
    
    var path: String {
        switch self {
        case .getEventList(userId: let userId, _, _, _):
            return "/api/v2/events/\(userId)"
        case .getEventDetail(userId: let userId, eventId: let eventId):
            return "/api/v2/events/\(userId)/\(eventId)"
        case .postEvent(userId: let userId, _) :
            return "/api/v2/events/\(userId)"
        case .putEvent(userId: let userId, eventId: let eventId, _):
            return "/api/v2/events/\(userId)/\(eventId)"
        case .deleteEvet(userId: let userId, eventId: let eventId):
            return "/api/v2/events/\(userId)/\(eventId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getEventList:
            return .get
        case .getEventDetail:
            return .get
        case .postEvent:
            return .post
        case .putEvent:
            return .put
        case .deleteEvet:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getEventList(_, year: let year, month: let month, day: let day):
            return .requestParameters(parameters: ["eventYear": year, "eventMonth" : month, "eventDate" : day],encoding: URLEncoding.queryString)
        case .getEventDetail:
            return .requestPlain
        case .postEvent(_, requestBody: let requestBody):
            return .uploadMultipart(multipartDataForEvent(for: requestBody))
        case .putEvent(_, _, requestBody: let requestBody):
            return .uploadMultipart(multipartDataForEvent(for: requestBody))
        case .deleteEvet:
            return .requestPlain
        }
    }
    
    private func multipartDataForEvent(for requestBody: EventRequestDTO) -> [Moya.MultipartFormData] {
        var multipartData: [Moya.MultipartFormData] = []
        
        multipartData.append(Moya.MultipartFormData(provider: .data("\(requestBody.eventTitle)".data(using: .utf8)!), name: "eventTitle"))
        multipartData.append(Moya.MultipartFormData(provider: .data("\(requestBody.eventWhat)".data(using: .utf8)!), name: "eventWhat"))
        multipartData.append(Moya.MultipartFormData(provider: .data("\(requestBody.eventWhere)".data(using: .utf8)!), name: "eventWhere"))
        multipartData.append(Moya.MultipartFormData(provider: .data("\(requestBody.withWho)".data(using: .utf8)!), name: "withWho"))
        multipartData.append(Moya.MultipartFormData(provider: .data("\(requestBody.eventYear)".data(using: .utf8)!), name: "eventYear"))
        multipartData.append(Moya.MultipartFormData(provider: .data("\(requestBody.eventMonth)".data(using: .utf8)!), name: "eventMonth"))
        multipartData.append(Moya.MultipartFormData(provider: .data("\(requestBody.eventDate)".data(using: .utf8)!), name: "eventDate"))
        
        for categoryId in requestBody.categoryIds {
            multipartData.append(Moya.MultipartFormData(provider: .data("\(categoryId)".data(using: .utf8)!), name: "categoryIds"))
        }
        
        for image in requestBody.images {
            multipartData.append(Moya.MultipartFormData(provider: .data(image), name: "images", fileName: "\(image)", mimeType: "image/jpeg"))
        }
        
        return multipartData
    }
}

