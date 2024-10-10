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
    
    @State private var name:String = ""
    @State private var email: String = ""
    @State private var socialId: String = ""
    @State private var socialLoginType: String = ""
    @State private var socialRefreshToken: String = ""
    @State private var socialAccessToken: String = ""

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack {
                    VStack(spacing: 15) {
                        HStack {
                            Image("cookiee_icon_big")
                        }
                        .frame(width: 184, height: 184)
                        HStack {
                            Image("cookiee_typo")
                        }
                    }
                    .position(x: geometry.size.width / 2, y: 280)


                    HStack {
                        GoogleLoginInButton(navigateToSignUp: $navigateToSignUp, navigateToHome: $navigateToHome, name: $name, email: $email, socialId: $socialId, socialLoginType: $socialLoginType, socialRefreshToken: $socialRefreshToken, socialAccessToken: $socialAccessToken)
                    }
                    .padding(.bottom, 5)

                    HStack {
                        AppleSignInButton(navigateToSignUp: $navigateToSignUp, navigateToHome: $navigateToHome, name: $name, email: $email, socialId: $socialId, socialLoginType: $socialLoginType, socialRefreshToken: $socialRefreshToken, socialAccessToken: $socialAccessToken)
                    }
                    .padding(.bottom, 145)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            // 로그인 성공 시 SignUpView로 이동
            .navigationDestination(isPresented: $navigateToSignUp) {
                SignUpView(email: email, name: name, socialId: socialId, socialLoginType: socialLoginType, socialRefreshToken: socialRefreshToken, socialAccessToken: socialAccessToken)
            }
            .navigationDestination(isPresented: $navigateToHome, destination: {
                TabBarView()
            })
        }
    }
}


//MARK: - 애플 로그인 버튼 & auth 처리
struct AppleSignInButton : View {
    @Binding var navigateToSignUp: Bool
    @Binding var navigateToHome: Bool
    
    @Binding var name: String
    @Binding var email: String
    @Binding var socialId: String
    @Binding var socialLoginType: String
    @Binding var socialRefreshToken: String
    @Binding var socialAccessToken: String
    
    @State var isNewMember: Bool = false
    
    
    var body: some View {
        HStack {
            Image("AppleIcon")
            Text("Apple 계정으로 로그인")
                .font(Font.Body1_SB)
                .foregroundStyle(Color.White)
        }
        .frame(width: 265, height: 37)
        .background(Color.Black)
        .cornerRadius(5)
        .overlay {
            SignInWithAppleButton(onRequest: { request in
                    request.requestedScopes = [.email, .fullName]
                }, onCompletion: { result in
                    switch result {
                    case .success(let auth):
                        switch auth.credential {
                        case let credential as ASAuthorizationAppleIDCredential:
                            name = String(describing: credential.fullName)
                            email =  String(describing: credential.email)
        
                            if  let authorizationCode = credential.authorizationCode,
                               let identityToken = credential.identityToken,
                               let authString = String(data: authorizationCode, encoding: .utf8),
                               let tokenString = String(data: identityToken, encoding: .utf8) {
                               print("authorizationCode to String: \(authString)")
                               print("identityToken to String: \(tokenString)")
                                
                                postAppleLogin(IdentityToken: tokenString, AuthorizationCode: authString)
                                
                           }

                        default:
                            break
                        }
                    case .failure(let error):
                        print(error)
                    };
                })
            .blendMode(.overlay)
        }
    }
    
    
    func postAppleLogin(IdentityToken: String, AuthorizationCode: String) {
        let apppleLoginService = AppleLoginService()
        let appleLoginRequest: AppleLoginRequestDTO = AppleLoginRequestDTO(IdentityToken: IdentityToken, AuthorizationCode: AuthorizationCode)
        
            
        apppleLoginService.postAppleLogin(request: appleLoginRequest){ result in
            switch result {
            case .success(let response):
                print("=====================================")
                print("애플 로그인 결과: \(response)")
                print("=====================================")

                // Auth 값 설정
                socialId = response.result?.socialId ?? ""
                socialLoginType = "apple"
                socialRefreshToken = response.result?.refreshToken ?? ""
                socialAccessToken = response.result?.accessToken ?? ""
                isNewMember = response.result?.isNewMember ?? false
                
            case .failure(let error):
                print("API Error: \(error)")
            }
        }
    }
}

//MARK: - 구글 로그인 버튼 & auth 처리
struct GoogleLoginInButton: View {
    @Binding var navigateToSignUp: Bool
    @Binding var navigateToHome: Bool
    
    @Binding var name: String
    @Binding var email: String
    @Binding var socialId: String
    @Binding var socialLoginType: String
    @Binding var socialRefreshToken: String
    @Binding var socialAccessToken: String
    
    @State var isNewMember: Bool = false
    

    var body: some View {
        Button {
            Task {
                do {
                    let loginSuccess = try await getGoogleUserID()
                    
                    if loginSuccess { // 구글 로그인 성공 여부 확인
                        if isNewMember {
                            navigateToSignUp = true // 신규 가입이면 회원가입으로
                        } else {
                            // 임시로 신규 회원이 아닐때에 키체인 등록
                            saveToKeychain(key: "accessToken", data: socialAccessToken)
                            saveToKeychain(key: "refreshToken", data: socialAccessToken)
                            
                            navigateToHome = true // 신규 가입이 아니면 홈으로
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
        .frame(width: 264, height: 36)
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
            return false // 실패 시 false 반환
        }
        email = user.profile!.email
        name = user.profile!.name

        // API 처리
        return try await withCheckedThrowingContinuation { continuation in
            let googleLoginService = GoogleLoginService()
            googleLoginService.getGoogleLogin(socialId: googleSocialId) { result in
                switch result {
                case .success(let response):
                    print("=====================================")
                    print("구글 로그인 결과: \(response)")
                    print("=====================================")

                    // Auth 값 설정
                    socialId = response.result.socialId
                    socialLoginType = "google"
                    socialRefreshToken = response.result.refreshToken ?? ""
                    socialAccessToken = response.result.accessToken ?? ""
                    isNewMember = response.result.isNewMember
                    
                    continuation.resume(returning: true) // 성공 시 true 반환
                case .failure(let error):
                    print("API Error: \(error)")
                    continuation.resume(returning: false) // 실패 시 false 반환
                }
            }
        }
    }
}



#Preview {
    SocialLoginView()
}
