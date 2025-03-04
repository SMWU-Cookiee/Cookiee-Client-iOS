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
            VStack {
                VStack {
                    Spacer()
                        .frame(height: 150)
                    Image("cookiee_icon_big")
                    Spacer()
                        .frame(height: 33)
                    Image("cookiee_typo")
                    Spacer()
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
                
                Spacer()
                    .frame(height: 150)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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

