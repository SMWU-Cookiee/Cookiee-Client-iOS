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
    @AppStorage("email") var email:String = ""
    @AppStorage("firstName") var firstName:String = ""
    @AppStorage("lastName") var lastName:String = ""
    @AppStorage("userId") var userId:String = ""
    
    var body: some View {
        if userId.isEmpty {
            // 애플로 로그인 하기
            SignInWithAppleButton(.continue) { request in
                request.requestedScopes = [.email, .fullName]
                
            } onCompletion: { result in
                switch result {
                case .success(let auth):
                    switch auth.credential {
                    case let credential as ASAuthorizationAppleIDCredential:
                        // User ID
                        let userId = credential.user
                        
                        // User Info
                        let email = credential.email
                        let firstName = credential.fullName?.givenName
                        let lastName = credential.fullName?.familyName
                        
                        self.email = email ?? ""
                        self.userId = userId
                        self.firstName = firstName ?? ""
                        self.lastName = lastName ?? ""
                        
                        
                    default:
                        break
                    }
                case .failure(let error):
                    print(error)
                }
            }
            .frame(height: 50)
            .cornerRadius(8)
        }
        else {
            // 로그인 되었을 때
           VStack {
               Text("User ID: \(userId)")
               Text("Email: \(email)")
               Text("First Name: \(firstName)")
               Text("Last Name: \(lastName)")
           }
           .padding()
        }
        
        
    }
}

#Preview {
    LoginView()
}
