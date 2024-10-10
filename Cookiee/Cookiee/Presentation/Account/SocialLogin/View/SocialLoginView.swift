//
//  SocialLoginView.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/11/24.
//

import SwiftUI
import AuthenticationServices

struct SocialLoginView: View {
    @ObservedObject var socialLoginViewModel = SocialLoginViewModel()

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
                        GoogleLoginInButton(
                            socialLoginViewModel: socialLoginViewModel
                        )
                    }
                    .padding(.bottom, 5)

                    HStack {
                        AppleSignInButton(
                            navigateToSignUp: $socialLoginViewModel.userInfo.navigateToSignUp,
                            navigateToHome: $socialLoginViewModel.userInfo.navigateToHome,
                            name: $socialLoginViewModel.userInfo.name,
                            email: $socialLoginViewModel.userInfo.email,
                            socialId: $socialLoginViewModel.userInfo.socialId,
                            socialLoginType: $socialLoginViewModel.userInfo.socialLoginType,
                            socialRefreshToken: $socialLoginViewModel.userInfo.socialRefreshToken,
                            socialAccessToken: $socialLoginViewModel.userInfo.socialAccessToken
                        )
                    }
                    .padding(.bottom, 145)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            // 로그인 성공 시 SignUpView로 이동
            .navigationDestination(isPresented: $socialLoginViewModel.userInfo.navigateToSignUp) {
                SignUpView(
                    email: socialLoginViewModel.userInfo.email,
                    name: socialLoginViewModel.userInfo.name,
                    socialId: socialLoginViewModel.userInfo.socialId,
                    socialLoginType: socialLoginViewModel.userInfo.socialLoginType,
                    socialRefreshToken: socialLoginViewModel.userInfo.socialRefreshToken,
                    socialAccessToken: socialLoginViewModel.userInfo.socialAccessToken
                )
            }
            .navigationDestination(isPresented: $socialLoginViewModel.userInfo.navigateToHome, destination: {
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
    @ObservedObject var socialLoginViewModel: SocialLoginViewModel

    var body: some View {
        Button {
            Task {
                do {
                    try await socialLoginViewModel.getGoogleUserID()
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
    
    
    
}



#Preview {
    SocialLoginView()
}
