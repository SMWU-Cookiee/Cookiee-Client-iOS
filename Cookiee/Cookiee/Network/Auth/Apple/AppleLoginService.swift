//
//  AppleLoginService.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/20/24.
//

import Foundation
import Moya

class AppleLoginService {
    let provider = MoyaProvider<AppleLoginAPI>()
    
    func postAppleLogin(request: AppleLoginRequestDTO, completion: @escaping (Result<AppleLoginResponseDTO, Error>) -> Void) {
        provider.request(.postAppleLogin(request: request)) { result in
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
                completion(.failure(error))
                print("postAppleLogin error:", error)
            }
        }
    }
}
