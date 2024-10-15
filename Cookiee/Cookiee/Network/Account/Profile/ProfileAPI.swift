//
//  ProfileAPI.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/15/24.
//

import Foundation
import Moya

enum ProfileAPI {
    case getUserProfile(userId: String)
    case putUserProfile(userId: String, requestBody: ProfilePutRequestDTO)
}

extension ProfileAPI: BaseTargetType {
    var headerType: HeaderType {
        switch self {
        case .getUserProfile:
            return .accessTokenHeaderForJson
        case .putUserProfile:
            return .accessTokenHeaderForJson
        }
    }
    
    var path: String {
        switch self {
        case .getUserProfile(userId: let userId):
            return "/api/users/\(userId)"
        case .putUserProfile(userId: let userId, requestBody: _):
            return "/api/users/\(userId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserProfile:
            return .get
        case .putUserProfile:
            return .put
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getUserProfile:
            return .requestPlain
        case .putUserProfile(userId: _, requestBody: let requestBody):
            return .uploadMultipart(multipartData(for: requestBody))
        }
    }
    
    private func multipartData(for requestBody: ProfilePutRequestDTO) -> [Moya.MultipartFormData] {
        var multipartData: [Moya.MultipartFormData] = []
        
        multipartData.append(Moya.MultipartFormData(provider: .data(requestBody.nickname.data(using: .utf8)!), name: "nickname"))
        multipartData.append(Moya.MultipartFormData(provider: .data(requestBody.selfDescription.data(using: .utf8)!), name: "selfDescription"))
        if requestBody.profileImage != nil {
            multipartData.append(Moya.MultipartFormData(provider: .data(requestBody.profileImage!), name: "profileImage", fileName: "profileImage", mimeType: "image/jpeg"))
        }
        
        return multipartData
    }
}
