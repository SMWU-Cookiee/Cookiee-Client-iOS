//
//  SocialLoginView.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/11/24.
//

import SwiftUI
import AuthenticationServices


struct SocialLoginView: View {
    var body: some View {
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
                    AppleSignInButton()
                }.padding(.bottom, 90)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

// * 애플 로그인 버튼
struct AppleSignInButton : View {
    @AppStorage("email") var email:String = ""
    @AppStorage("fullName") var fullName:String = ""

    let loginService = AppleLoginService()
    
    var body: some View {
        SignInWithAppleButton(onRequest: { request in
            request.requestedScopes = [.email, .fullName]
        }, onCompletion: { result in
            switch result {
            case .success(let auth):
                switch auth.credential {
                case let credential as ASAuthorizationAppleIDCredential:
                    if let authorizationCode = credential.authorizationCode,
                       let identityToken = credential.identityToken,
                       let authString = String(data: authorizationCode, encoding: .utf8),
                       let tokenString = String(data: identityToken, encoding: .utf8) {
                        let request = AppleLoginRequestDTO(IdentityToken: tokenString, AuthorizationCode: authString)
                        loginService.postAppleLogin(request: request) { result in
                            switch result {
                            case .success(let response):
                                print("Login success: \(response)")
                                print()
                                print()
                                print("authString: \(authString)")
                                print("tokenString: \(tokenString)")
                            case .failure(let error):
                                print("Login failed: \(error)")
                                print()
                                print()
                                print("authString: \(authString)")
                                print("tokenString: \(tokenString)")
                                
                            }
                        }
                   }
                    
                default:
                    break
                }
            case .failure(let error):
                print(error)
            };
        })                
        .frame(width : UIScreen.main.bounds.width * 0.7, height:45)
    }
}


#Preview {
    SocialLoginView()
}
