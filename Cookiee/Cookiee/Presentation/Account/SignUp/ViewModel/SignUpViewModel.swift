//
//  SocialLoginViewModel.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/10/24.
//

import Foundation
import UIKit

class SignUpViewModel: ObservableObject {
    @Published var isSignUpSuccess: Bool = false
    
    func postSignUp(email: String, name: String, nickname: String, selfDescription: String, socialId: String, socialLoginType: String, selectedUIImage: UIImage?) {
        
        let email: String = email
        let name: String = name
        let nickname: String = nickname
        let selfDescription: String = selfDescription
        let socialId: String = socialId
        let socialLoginType: String = socialLoginType
        let selectedUIImage: UIImage? = selectedUIImage
        
        let imageData: Data?
        
        if selectedUIImage != nil {
            let data = selectedUIImage!.jpegData(compressionQuality: 1.0)
            imageData = data
        } else {
            imageData = nil
        }
        
        let signUpService = SignUpService()

        let signUpRequest = SignUpRequestDTO(email: email, name: name, nickname: nickname, selfDescription: selfDescription, socialId: socialId, socialLoginType: socialLoginType, image: imageData)
        
        signUpService.postSignUp(requestBody: signUpRequest) { result in
            switch result {
            case .success(let response):
                saveToKeychain(key: "accessToken", data: response.result.accessToken)
                saveToKeychain(key: "refreshToken", data: response.result.refreshToken)
                saveToKeychain(key: "userId", data: response.result.userId.description)
                
                self.isSignUpSuccess = true
                print(response)
        
            case .failure(let error):
                print("postSignUp error:", error.localizedDescription)
            }
        }
    }
}
