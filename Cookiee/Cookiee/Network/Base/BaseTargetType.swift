//
//  BaseTargetType.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/18/24.
//

import Foundation
import Moya

enum HeaderType {
    case noneHeader
    case accessTokenHeaderForJson
    case accessTokenHeaderForMultipart
    case refreshTokenHeader
}

protocol BaseTargetType: TargetType {
    var headerType: HeaderType { get }
}

extension BaseTargetType {
    
    var baseURL: URL {
            return URL(string: "https://cookiee.info")!
        }
        
    var headers: [String: String]? {
        switch headerType {
            case .noneHeader:
                return .none
            
            case .accessTokenHeaderForJson:
                guard let accessToken = loadFromKeychain(key: "accessToken") else { return [:] }
                
                let header = ["Authorization": "Bearer \(accessToken)",
                            "Content-Type": "application/json"]
                return header
            
            case .accessTokenHeaderForMultipart:
                guard let accessToken = loadFromKeychain(key: "accessToken") else { return [:] }
                
                let header = ["Authorization": "Bearer \(accessToken)",
                            "Content-Type": "multipart/form-data"]
                return header
                
                
            case .refreshTokenHeader:
                guard let accessToken = loadFromKeychain(key: "accessToken") else { return [:] }
                guard let refreshToken = loadFromKeychain(key: "accessToken") else { return [:] }
        

                let header = ["Content-Type": "application/json",
                              "Authorization": "Bearer \(accessToken)",
                              "RefreshToken": "Bearer \(refreshToken)"]
                return header
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
