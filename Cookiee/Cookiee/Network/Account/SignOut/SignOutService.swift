//
//  SignOutService.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/9/24.
//

import Foundation
import Moya

class SignOutService {
    let provider = MoyaProvider<SignOutAPI>()
    
    func deleteSignOut(completion: @escaping (Result<SignOutResponseDTO, Error>) -> Void) {
        provider.request(.deleteSignOut) { result in
            switch result {
            case .success(let response):
                do {
                    let loginResponse = try JSONDecoder().decode(SignOutResponseDTO.self, from: response.data)
                    completion(.success(loginResponse))
                } catch {
                    completion(.failure(error))
                    print("deleteSignOut Decoding error:", error)
                }
            case .failure(let error):
                completion(.failure(error))
                print("deleteSignOut error:", error)
            }
        }
    }
}
