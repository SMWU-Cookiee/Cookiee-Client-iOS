//
//  TokenInterceptor.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/4/24.
//

import Foundation
import Alamofire

final class TokenInterceptor: RequestInterceptor {
    
    static let shared = TokenInterceptor()

    private init() {}
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("retry 진입")
        
        guard let response = request.task?.response as? HTTPURLResponse else {
            completion(.doNotRetryWithError(error))
            print("retry : response가 없음")
            return
        }

        if response.statusCode == 401 {
            print("retry : 401 오류 발생")
            refreshAccessToken(request: request, completion: completion)
        } else if response.statusCode == 500 {
            print("retry : 500 서버 오류 발생, 토큰 만료 가능성 있음")
            refreshAccessToken(request: request, completion: completion)
        } else {
            completion(.doNotRetryWithError(error))
            print("retry : 401이나 500이 아님")
        }
    }

    private func refreshAccessToken(request: Request, completion: @escaping (RetryResult) -> Void) {
        let tokenRefreshService = TokenRefreshService()
        tokenRefreshService.postRefreshToken() { result in
            switch result {
            case .success(let response):
                print("🔐 postRefreshToken Response: \(response)")
                print("🔐 Access Token 재설정")
                saveToKeychain(key: "accessToken", data: response.result.accessToken)
                completion(.retry)
            case .failure(let error):
                print("🔐 postRefreshToken Error: \(error)")
                completion(.doNotRetryWithError(error))
            }
        }
    }
}
