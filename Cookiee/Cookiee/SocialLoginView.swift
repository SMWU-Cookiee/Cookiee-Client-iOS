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
            AppleSignInButton()
        }
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
    SocialLoginView()
}
