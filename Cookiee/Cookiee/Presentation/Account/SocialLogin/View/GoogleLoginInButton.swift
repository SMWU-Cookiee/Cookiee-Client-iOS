//
//  GoogleLoginInButton.swift
//  Cookiee
//
//  Created by minseo Kyung on 12/18/24.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct GoogleLoginInButton: View {
    @Binding var navigateToSignUp: Bool
    @Binding var navigateToHome: Bool
    
    @ObservedObject var socialLoginViewModel: SocialLoginViewModel
    @State private var isNewMember: Bool = false
    
    var body: some View {
        Button {
            Task {
                do {
                    let loginSuccess = try await getGoogleUserID()
                    if loginSuccess {
                        if isNewMember {
                            navigateToSignUp = true
                        } else {
                            navigateToHome = true
                        }
                    }
                } catch {
                    print("Google login failed with error: \(error)")
                }
            }
        } label: {
            Image("GoogleLogos")
            Text("Google 계정으로 로그인")
                .font(Font.Body1_SB)
                .foregroundStyle(Color.Gray06)
        }
        .frame(width: 265, height: 37)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.Gray04, lineWidth: 1)
        )
    }
    
    func getGoogleUserID() async throws -> Bool {
        guard let TopUIViewController = FindTopUIViewController() else {
            throw URLError(.cannotFindHost)
        }
        
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: TopUIViewController)
        
        let user = gidSignInResult.user
        guard let googleSocialId = user.userID else {
            print("Error: No User ID found")
            return false
        }
        
        socialLoginViewModel.email = user.profile?.email
        socialLoginViewModel.name = user.profile?.name

        return try await withCheckedThrowingContinuation { continuation in
            let googleLoginService = GoogleLoginService()
            googleLoginService.getGoogleLogin(socialId: googleSocialId) { result in
                switch result {
                case .success(let response):
                    print("=====================================")
                    print("구글 로그인 결과: \(response)")
                    print("=====================================")
                    socialLoginViewModel.socialId = response.result.socialId
                    socialLoginViewModel.socialLoginType = "google"
                    if response.result.refreshToken != nil {
                        socialLoginViewModel.socialRefreshToken = response.result.refreshToken
                        saveToKeychain(key: "refreshToken", data: response.result.refreshToken!)
                    }
                    if response.result.accessToken != nil {
                        socialLoginViewModel.socialAccessToken = response.result.accessToken
                        saveToKeychain(key: "accessToken", data: response.result.accessToken!)
                    }
                    isNewMember = response.result.isNewMember
                    
                    continuation.resume(returning: true)
                case .failure(let error):
                    print("API Error: \(error)")
                    continuation.resume(returning: false)
                }
            }
        }
    }
}
