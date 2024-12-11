//
//  AppleLoginService.swift
//  Cookiee
//
//  Created by minseo Kyung on 12/11/24.
//

import Foundation
import Moya

class AppleLoginService {
    let provider = MoyaProvider<AppleLoginAPI>()
    
    func postAppleLogin(identityToken: String, authorizationCode: String, completion: @escaping (Result<AppleLoginResponseDTO, Error>) -> Void) {
        provider.request(.postApplelogin(identityToken: identityToken, authorizationCode: authorizationCode)) { result in
            switch result {
            case .success(let response):
                do {
                    let loginResponse = try JSONDecoder().decode(AppleLoginResponseDTO.self, from: response.data)
                    completion(.success(loginResponse))
                } catch {
                    completion(.failure(error))
                    print("postAppleLogin Decoding error:", error)
                }
            case .failure(let error):
                if let response = error.response {
                    print("Response Data:", String(data: response.data, encoding: .utf8) ?? "No response body")
                }
                completion(.failure(error))
                print("postAppleLogin error:", error)
            }
        }
    }
}
