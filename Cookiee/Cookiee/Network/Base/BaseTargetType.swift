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
    case accessTokenHeaderForGet
    case accessTokenHeaderForGeneral
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
            case .accessTokenHeaderForGet:
                guard let accessToken = loadFromKeychain(key: "accessToken") else { return [:] }
                
                let header = ["Authorization": "Bearer \(accessToken)"]
                
                return header
            case .accessTokenHeaderForGeneral:
                guard let accessToken = loadFromKeychain(key: "accessToken") else { return [:] }

                let header = ["Content-Type": "application/json",
                              "Authorization": "Bearer \(accessToken)"]
                return header
        }
    }
}
