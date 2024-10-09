//
//  SignUpAPI.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/10/24.
//

import Foundation
import Moya

enum SignUpAPI {
    case postSignUp(requestBody: SignUpRequestDTO)
}

extension SignUpAPI: BaseTargetType {
    var headerType: HeaderType {
        .accessTokenHeaderForMultipart
    }
    
    var path: String {
        switch self {
        case .postSignUp(_):
            return "/api/auth/signup"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postSignUp(_):
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .postSignUp(let requestBody):
            return .uploadMultipart(multipartData(for: requestBody))
        }
    }
    
    private func multipartData(for requestBody: SignUpRequestDTO) -> [Moya.MultipartFormData] {
        var multipartData: [Moya.MultipartFormData] = []
        
        multipartData.append(Moya.MultipartFormData(provider: .data(requestBody.email.data(using: .utf8)!), name: "email"))
        multipartData.append(Moya.MultipartFormData(provider: .data(requestBody.name.data(using: .utf8)!), name: "name"))
        multipartData.append(Moya.MultipartFormData(provider: .data(requestBody.nickname.data(using: .utf8)!), name: "nickname"))
        multipartData.append(Moya.MultipartFormData(provider: .data(requestBody.selfDescription.data(using: .utf8)!), name: "selfDescription"))
        multipartData.append(Moya.MultipartFormData(provider: .data(requestBody.socialId.data(using: .utf8)!), name: "socialId"))
        multipartData.append(Moya.MultipartFormData(provider: .data(requestBody.socialLoginType.data(using: .utf8)!), name: "socialLoginType"))
        if requestBody.image != nil {
            multipartData.append(Moya.MultipartFormData(provider: .data(requestBody.image!), name: "image", fileName: "name", mimeType: "image/jpeg"))
        }
        
        return multipartData
    }
}
