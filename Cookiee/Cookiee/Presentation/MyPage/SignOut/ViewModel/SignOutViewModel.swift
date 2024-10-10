//
//  SignOutViewModel.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/10/24.
//

import Foundation

class SignOutViewModel: ObservableObject {
    @Published var isSignOutSuccess: Bool = false
    
    func deleteSignOut() {
        let signOutService = SignOutService()
        
        signOutService.deleteSignOut() { result in
            switch result {
            case .success:
                deleteFromKeychain(key: "accessToken")
                deleteFromKeychain(key: "refreshToken")
                deleteFromKeychain(key: "userId")
                
                self.isSignOutSuccess = true
                print("탈퇴 성공", self.isSignOutSuccess)
            case .failure:
                self.isSignOutSuccess = false
                print("탈퇴 실패", self.isSignOutSuccess)
            }
        }
    }
}
