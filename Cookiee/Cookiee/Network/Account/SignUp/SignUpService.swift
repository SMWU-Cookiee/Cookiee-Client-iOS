//
//  SignUpService.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/10/24.
//

import Foundation
import Moya


class SignUpService {
    let provider = MoyaProvider<SignUpAPI>()
    
    func postSignUp(requestBody: SignUpRequestDTO, completion: @escaping (Result<SignUpResponseDTO, Error>) -> Void) {
        provider.request(.postSignUp(requestBody: requestBody)) { result in
            switch result {
            case .success(let response):
                do {
                    let response = try JSONDecoder().decode(SignUpResponseDTO.self, from: response.data)
                    completion(.success(response))
                } catch {
                    completion(.failure(error))
                    print("postSignUp Decoding error:", error)
                }
            case .failure(let error):
                completion(.failure(error))
                print("postSignUp error:", error.errorDescription as Any)
            }
        }
    }
}

