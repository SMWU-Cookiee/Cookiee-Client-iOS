//
//  SocialLoginViewModel.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/10/24.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift

struct SocialLoginUserInfo {
    var navigateToSignUp: Bool = false
    var navigateToHome: Bool = false
    
    var name:String = ""
    var email: String = ""
    var socialId: String = ""
    var socialLoginType: String = ""
    var socialRefreshToken: String = ""
    var socialAccessToken: String = ""
    var isNewMember: Bool = false
}

class SocialLoginViewModel: ObservableObject {
    @Published var userInfo = SocialLoginUserInfo()
    @Published var isSociaLoginSuccess: Bool = false
    
    func getGoogleUserID() async {
        await MainActor.run {
            guard let topUIViewController = FindTopUIViewController() else {
                print("Unable to find top UIViewController.")
                return
            }
            
            Task {
                do {
                    let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topUIViewController)
                    
                    let user = gidSignInResult.user
                    let googleSocialId = user.userID
                    
                    if let googleSocialId = googleSocialId {
                        self.userInfo.email = user.profile?.email ?? ""
                        self.userInfo.name = user.profile?.name ?? ""
                        
                        let googleLoginService = GoogleLoginService()
                        googleLoginService.getGoogleLogin(socialId: googleSocialId) { result in
                            switch result {
                            case .success(let response):
                                print("=====================================")
                                print("구글 로그인 결과: \(response)")
                                print("=====================================")
                                
                                // Auth 값 설정
                                self.userInfo.socialId = response.result.socialId
                                self.userInfo.socialLoginType = "google"
                                self.userInfo.socialRefreshToken = response.result.refreshToken ?? ""
                                self.userInfo.socialAccessToken = response.result.accessToken ?? ""
                                self.userInfo.isNewMember = response.result.isNewMember
                                
                                if self.userInfo.isNewMember {
                                    self.userInfo.navigateToSignUp = true
                                } else {
                                    saveToKeychain(key: "accessToken", data: self.userInfo.socialAccessToken)
                                    saveToKeychain(key: "refreshToken", data: self.userInfo.socialRefreshToken)
                                    
                                    self.userInfo.navigateToHome = true
                                }
                                
                                self.isSociaLoginSuccess = true
                                
                            case .failure(let error):
                                print("구글 로그인 실패: \(error)")
                                self.isSociaLoginSuccess = false
                            }
                        }
                    }
                } catch {
                    print("Error during Google SignIn: \(error)")
                }
            }
        }
    }

}
