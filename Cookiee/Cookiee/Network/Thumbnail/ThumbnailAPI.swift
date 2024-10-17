//
//  ThumbnailAPI.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/4/24.
//

import Foundation
import Moya

enum ThumbnailAPI {
    case getThumbnailList(userId: String)
    case getTumbnailByDate(userId: String, year: Int32, month: Int32, day: Int32)
    case postThumbnail(userId: String, requestBody: ThumbnailRequestDTO)
    case deleteThumbnail(userId: String, thumbnailId: String)
    case putThumbnail(userId: String, thumbnailId: String, newThumbnail: Data)
}

extension ThumbnailAPI: BaseTargetType {
    var headerType: HeaderType {
        switch self {
        case .getThumbnailList:
            return .accessTokenHeaderForJson
        case .getTumbnailByDate:
            return .accessTokenHeaderForJson
        case .postThumbnail:
            return .accessTokenHeaderForJson
        case .deleteThumbnail:
            return .accessTokenHeaderForJson
        case .putThumbnail:
            return .accessTokenHeaderForJson
        }
    }
    
    var path: String {
        switch self {
        case .getThumbnailList(userId: let userId):
            return "/api/v2/thumbnails/\(userId)"
        case .getTumbnailByDate(userId: let userId, _, _, _):
            return "/api/v2/thumbnails/date/\(userId)"
        case .postThumbnail(userId: let userId, _):
            return "/api/v2/thumbnails/\(userId)"
        case .deleteThumbnail(userId: let userId, thumbnailId: let thumbnailId):
            return "/api/v2/thumbnails/\(userId)/\(thumbnailId)"
        case .putThumbnail(userId: let userId, thumbnailId: let thumbnailId, _):
            return "/api/v2/thumbnails/\(userId)/\(thumbnailId)"

        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getThumbnailList:
            return .get
        case .getTumbnailByDate:
            return .get
        case .postThumbnail:
            return .post
        case .deleteThumbnail:
            return .delete
        case .putThumbnail:
            return .put
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getThumbnailList(_):
            return .requestPlain
        case .getTumbnailByDate(_, year: let year, month: let month, day: let day):
            return .requestParameters(parameters: ["year": year, "month" : month, "day" : day],encoding: URLEncoding.queryString)
        case .postThumbnail(_, requestBody: let requestBody):
            return .uploadMultipart(multipartDataForPost(for: requestBody))
        case .deleteThumbnail(_, _):
            return .requestPlain
        case .putThumbnail(_, _, newThumbnail: let newThumbnail):
            return .uploadMultipart(multipartDataForPut(for: newThumbnail))
        }
    }
    
    private func multipartDataForPost(for requestBody: ThumbnailRequestDTO) -> [Moya.MultipartFormData] {
        var multipartData: [Moya.MultipartFormData] = []
        
        multipartData.append(Moya.MultipartFormData(provider: .data("\(requestBody.eventDate)".data(using: .utf8)!), name: "eventDate"))
        multipartData.append(Moya.MultipartFormData(provider: .data("\(requestBody.eventMonth)".data(using: .utf8)!), name: "eventMonth"))
        multipartData.append(Moya.MultipartFormData(provider: .data("\(requestBody.eventYear)".data(using: .utf8)!), name: "eventYear"))
        multipartData.append(Moya.MultipartFormData(provider: .data(requestBody.thumbnail!), name: "thumbnail", fileName: "thumbnail", mimeType: "image/jpeg"))
        
        return multipartData
    }
    
    private func multipartDataForPut(for newThumbnail: Data) -> [Moya.MultipartFormData] {
        var multipartData: [Moya.MultipartFormData] = []
        
        multipartData.append(Moya.MultipartFormData(provider: .data(newThumbnail), name: "thumbnail", fileName: "thumbnail", mimeType: "image/jpeg"))
        
        return multipartData
    }
}
