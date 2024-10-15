//
//  ProfileEidtViewModel.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/15/24.
//

import Foundation

struct UserProfileData {
    var nickname: String
    var selfDescription: String
    var profileImage: String?
}

class ProfileViewModel: ObservableObject {
    @Published var isSuccess: Bool = false
    @Published var profile = UserProfileData(nickname: "", selfDescription: "", profileImage: nil)
    
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
}
