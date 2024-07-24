//
//  ContentView.swift
//  Cookiee
//
//  Created by minseo Kyung on 7/18/24.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    var body: some View {
        VStack {
            AppleSignInButton()
        }
        .padding()
    }
}

// * 애플 로그인 버튼
struct AppleSignInButton : View {
    var body: some View {
        SignInWithAppleButton(onRequest: { request in
            request.requestedScopes = [.fullName, .email]
        }, onCompletion: {result in
            switch result {
            case .success(let authResults):
                print("Apple Login Successful")
                switch authResults.credential{
                    case let appleIDCredential as ASAuthorizationAppleIDCredential:
                       // 계정 정보 가져오기
                        let UserIdentifier = appleIDCredential.user
                        let fullName = appleIDCredential.fullName
                        let name =  (fullName?.familyName ?? "") + (fullName?.givenName ?? "")
                        let email = appleIDCredential.email
                        let IdentityToken = String(data: appleIDCredential.identityToken!, encoding: .utf8)
                        let AuthorizationCode = String(data: appleIDCredential.authorizationCode!, encoding: .utf8)
                default:
                    break
                }
            case .failure(let error):
                print(error.localizedDescription)
                print("error")
            }
        })
        .frame(width : UIScreen.main.bounds.width * 0.7, height:45)
    }
}

#Preview {
    LoginView()
}
