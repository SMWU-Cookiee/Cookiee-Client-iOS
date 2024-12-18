//
//  SocialLoginView.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/11/24.
//

import SwiftUI

struct SocialLoginView: View {
    @State private var navigateToTermsOfService: Bool = false
    @State private var navigateToHome: Bool = false
    
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
                            navigateToSignUp: $navigateToTermsOfService,
                            navigateToHome: $navigateToHome,
                            socialLoginViewModel: socialLoginViewModel
                        )
                    }
                    .padding(.bottom, 11)

                    HStack {
                        AppleSignInButton(
                            navigateToSignUp: $navigateToTermsOfService,
                            navigateToHome: $navigateToHome,
                            socialLoginViewModel: socialLoginViewModel
                        )
                    }
                    .padding(.bottom, 90)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationDestination(isPresented: $navigateToTermsOfService) {
                TermsOfServiceView(socialLoginViewModel: socialLoginViewModel)
            }
            .navigationDestination(isPresented: $navigateToHome, destination: {
                TabBarView()
            })
        }
        .navigationBarBackButtonHidden(true)
    }
}

