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
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401
        else {
            completion(.doNotRetryWithError(error))
            print("retry : 401이 아님")
            return
        }

        let tokenRefreshService = TokenRefreshService()
        tokenRefreshService.postRefreshToken() { result in
            switch result {
            case .success(let response):
                print("@@@ postRefreshToken Response: \(response)")
                saveToKeychain(key: "accessToken", data: response.result.accessToken)
                completion(.retry)
            case .failure(let error):
                print("@@@ postRefreshToken Error: \(error)")
                completion(.doNotRetryWithError(error))
            }
        }
    }
}
