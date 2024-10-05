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
}

extension ThumbnailAPI: BaseTargetType {
    var headerType: HeaderType {
        .accessTokenHeaderForJson
    }
    
    var path: String {
        switch self {
        case .getThumbnailList(userId: let userId):
            return "/api/v2/thumbnails/\(userId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getThumbnailList:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getThumbnailList(_):
            return .requestPlain
        }
    }
    
    
}
