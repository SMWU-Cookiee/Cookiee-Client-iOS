//
//  LogOutViewModel.swift
//  Cookiee
//
//  Created by minseo Kyung on 12/24/24.
//

import Foundation

class LogOutViewModel: ObservableObject {
    @Published var isLogOutSuccess: Bool = false
    
    func deleteSignOut() {
        let logOutService = LogOutService()
        
        logOutService.putLogOut() { result in
            switch result {
            case .success:
                deleteFromKeychain(key: "accessToken")
                deleteFromKeychain(key: "refreshToken")
                deleteFromKeychain(key: "userId")
                
                self.isLogOutSuccess = true
                print("로그아웃 성공", self.isLogOutSuccess)
            case .failure:
                self.isLogOutSuccess = false
                print("로그아웃 실패", self.isLogOutSuccess)
            }
        }
    }
}
