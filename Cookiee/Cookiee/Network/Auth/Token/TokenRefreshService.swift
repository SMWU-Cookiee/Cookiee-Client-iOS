//
//  TokenRefreshService.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/4/24.
//

import Foundation
import Moya

final class TokenRefreshService {
    let provider = MoyaProvider<TokenRefreshAPI>()
    
    func postRefreshToken(completion: @escaping (Result<TokenRefreshResponseDTO, Error>) -> Void) {
        provider.request(.postRefreshToken) { result in
            switch result {
            case .success(let response):
                do {
                    let refreshResponse = try JSONDecoder().decode(TokenRefreshResponseDTO.self, from: response.data)
                    completion(.success(refreshResponse))
                } catch {
                    completion(.failure(error))
                    print("TokenRefreshService.postRefreshToken 디코딩 에러 : ", error)
                }
            case .failure(let error):
                completion(.failure(error))
                print("TokenRefreshService.postRefreshToken 에버 발생 : ", error)
            }
        }
    }
}
