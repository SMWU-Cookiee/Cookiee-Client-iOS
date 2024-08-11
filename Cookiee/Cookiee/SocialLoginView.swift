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
        VStack {
            HStack {
                Image("CookieeIcon")
            }
            .padding(.bottom, 10)
            HStack {
                Image("cookiee_typo")
            }
            .padding(.bottom, 170)
            HStack {
                AppleSignInButton()
            }
        }
    }
}

// * 애플 로그인 버튼
struct AppleSignInButton : View {
    @AppStorage("email") var email:String = ""
    @AppStorage("fullName") var fullName:String = ""

    
    var body: some View {
        SignInWithAppleButton(onRequest: { request in
            request.requestedScopes = [.email, .fullName]
        }, onCompletion: { result in
            switch result {
            case .success(let auth):
                switch auth.credential {
                case let credential as ASAuthorizationAppleIDCredential:
                    // User ID
                    let userId = credential.user
                    let fullName = credential.fullName
                    let email = credential.email
                              
                    if  let authorizationCode = credential.authorizationCode,
                       let identityToken = credential.identityToken,
                       let authString = String(data: authorizationCode, encoding: .utf8),
                       let tokenString = String(data: identityToken, encoding: .utf8) {
                       print("authorizationCode: \(authorizationCode)")
                       print("identityToken: \(identityToken)")
                       print("authString: \(authString)")
                       print("tokenString: \(tokenString)")
                   }
                    
                    print("userId: \(userId)")
                    print("fullName: \(String(describing: fullName))")
                    print("email: \(String(describing: email))")
                    
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
