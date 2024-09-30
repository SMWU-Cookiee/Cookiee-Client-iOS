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
                    GoogleLoginInButton()
                }.padding(.bottom, 11)
                
                HStack {
                    AppleSignInButton()
                }.padding(.bottom, 90)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

//MARK: - 애플 로그인 버튼 & auth 처리
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
                       print("authorizationCode to String: \(authString)")
                       print("identityToken to String: \(tokenString)")
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

//MARK: - 구글 로그인 버튼 & auth 처리
struct GoogleLoginInButton: View {
    
    var body: some View {
        Button {
            Task {
                 do {
                     try await getGoogleUserID()
                     
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
    
    func getGoogleUserID() async throws {
        guard let TopUIViewController = FindTopUIViewController() else {
            throw URLError(.cannotFindHost)
        }
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: TopUIViewController)
        
        print("======google login======")
        let user = gidSignInResult.user
        print("User ID: \(user.userID ?? "No User ID")")
        print("========================")
        
        // API 처리
           
    }
    
}

#Preview {
    SocialLoginView()
}
