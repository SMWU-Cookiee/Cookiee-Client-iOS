//
//  SocialLoginView.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/11/24.
//

import SwiftUI
import AuthenticationServices

import GoogleSignIn
import GoogleSignInSwift

struct SocialLoginView: View {
    @State private var navigateToSignUp: Bool = false // 회원가입으로 이동
    @State private var navigateToHome: Bool = false // 홈으로 이동
    
    @ObservedObject var socialLoginViewModel = SocialLoginViewModel()

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack {
                    HStack {
                        HStack {
                            Image("cookiee_icon_big")
                        }
                        .position(x: geometry.size.width / 2, y: 216)
                        HStack {
                            Image("cookiee_typo")
                        }
                        .position(x: 0, y: 350)
                    }

                    HStack {
                        GoogleLoginInButton(
                            navigateToSignUp: $navigateToSignUp,
                            navigateToHome: $navigateToHome,
                            socialLoginViewModel: socialLoginViewModel
                        )
                    }
                    .padding(.bottom, 11)

                    HStack {
                        AppleSignInButton(
                            navigateToSignUp: $navigateToSignUp,
                            navigateToHome: $navigateToHome,
                            socialLoginViewModel: socialLoginViewModel
                        )
                    }
                    .padding(.bottom, 90)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationDestination(isPresented: $navigateToSignUp) {
                SignUpView(socialLoginViewModel: socialLoginViewModel)
            }
            .navigationDestination(isPresented: $navigateToHome, destination: {
                TabBarView()
            })
        }
    }
}

// MARK: - AppleSignInButton
struct AppleSignInButton: View {
    @Binding var navigateToSignUp: Bool
    @Binding var navigateToHome: Bool
    
    @ObservedObject var socialLoginViewModel: SocialLoginViewModel
    @State private var isNewMember: Bool = false
    
    var body: some View {
        Button {
        } label: {
            Image("AppleIcon")
            Text("Apple 계정으로 로그인")
                .font(Font.Body1_SB)
                .foregroundStyle(Color.white)
        }
        .frame(width: 265, height: 37)
        .background(Color.black)
        .cornerRadius(5)
        .overlay(
            SignInWithAppleButton(onRequest: { request in
                request.requestedScopes = [.email, .fullName]
            }, onCompletion: { result in
                switch result {
                case .success(let auth):
                    switch auth.credential {
                    case let credential as ASAuthorizationAppleIDCredential:
                        handleAppleCredential(credential: credential)
                    default:
                        break
                    }
                case .failure(let error):
                    print(error)
                }
            })
        )
    }
    
    private func handleAppleCredential(credential: ASAuthorizationAppleIDCredential) {
        if let authorizationCode = credential.authorizationCode,
           let identityToken = credential.identityToken,
           let authString = String(data: authorizationCode, encoding: .utf8),
           let tokenString = String(data: identityToken, encoding: .utf8) {
            
            Task {
                do {
                    let success = try await postAppleLogin(identityToken: tokenString, authorizationCode: authString)
                    if success {
                        if isNewMember {
                            navigateToSignUp = true
                        } else {
                            navigateToHome = true
                        }
                    }
                } catch {
                    print("Apple login failed with error: \(error)")
                }
            }
        }
    }

    func postAppleLogin(identityToken: String, authorizationCode: String) async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            let appleLoginService = AppleLoginService()
            appleLoginService.postAppleLogin(identityToken: identityToken, authorizationCode: authorizationCode) { result in
                switch result {
                case .success(let response):
                    print("=====================================")
                    print("애플 로그인 결과: \(response)")
                    print("=====================================")
                    socialLoginViewModel.email = response.result.email
                    socialLoginViewModel.name = response.result.name
                    socialLoginViewModel.socialId = response.result.socialId
                    socialLoginViewModel.socialLoginType = "apple"
                    socialLoginViewModel.socialRefreshToken = response.result.refreshToken ?? ""
                    socialLoginViewModel.socialAccessToken = response.result.accessToken ?? ""
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

// MARK: - GoogleLoginInButton
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
                    socialLoginViewModel.socialRefreshToken = response.result.refreshToken ?? ""
                    socialLoginViewModel.socialAccessToken = response.result.accessToken ?? ""
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

