//
//  ProfileEidtViewModel.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/15/24.
//

import Foundation
import UIKit

struct UserProfileData {
    var nickname: String
    var selfDescription: String
    var profileImage: String?
}

class ProfileViewModel: ObservableObject {
    @Published var isSuccess: Bool = false
    @Published var profile = UserProfileData(nickname: "", selfDescription: "", profileImage: nil)
    @Published var newSelectedImage: UIImage?
    
    let service = ProfileService()
    
    func loadUserProfile() {
        service.getProfile() { result in
            switch result {
            case .success(let profileResponse):
                self.profile.nickname = profileResponse.result.nickname
                self.profile.profileImage = profileResponse.result.profileImage
                self.profile.selfDescription = profileResponse.result.selfDescription
                
                print("✅ loadUserProfile 성공\n")
            case .failure(let error):
                print("❌ loadUserProfile 실패\n", error)
            }
        }
    }
    
    func updateUserProfile(nickname: String, selfDescription: String, newUIImage: UIImage?) {
        let imageData: Data?
        
        if newUIImage != nil {
            let data = newUIImage!.jpegData(compressionQuality: 1.0)
            imageData = data
        } else {
            imageData = nil
        }
        
        print("profile.nickname: \(profile.nickname)")
        print("selfDescription: \(profile.selfDescription)")
              
        
        let request = ProfilePutRequestDTO(
            nickname: (nickname.isEmpty ? profile.nickname : nickname),
            selfDescription:(selfDescription.isEmpty ? profile.selfDescription : selfDescription),
            profileImage: imageData
        )
        
        
        service.putProfile(requestBody: request) { result in
            switch result {
            case .success:
                self.isSuccess = true
                print("✅ putProfile 성공\n")
            case .failure(let error):
                print("❌ putProfile 실패\n", error)
            }
        }
    }
}
