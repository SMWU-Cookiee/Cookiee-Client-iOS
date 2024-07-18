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
        SignInWithAppleButton(onRequest: { _ in
        }, onCompletion: {_ in 
        })
        .frame(width : UIScreen.main.bounds.width * 0.7, height:45)
    }
}

#Preview {
    LoginView()
}
