//
//  SocialLoginView.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/11/24.
//

import SwiftUI
import AuthenticationServices


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

// MARK: - DelegateHandler
class AppleSignInHandler: NSObject, ObservableObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    @Binding var navigateToSignUp: Bool
    @Binding var navigateToHome: Bool
    @Published var isNewMember: Bool = false

    @ObservedObject var socialLoginViewModel: SocialLoginViewModel

    init(navigateToSignUp: Binding<Bool>, navigateToHome: Binding<Bool>, socialLoginViewModel: SocialLoginViewModel) {
            self._navigateToSignUp = navigateToSignUp
            self._navigateToHome = navigateToHome
            self.socialLoginViewModel = socialLoginViewModel
        }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            fatalError("AppleSignInHandler - presentationAnchor: No key window found")
        }
        return window
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            handleAppleCredential(credential: credential)
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple Login Error: \(error.localizedDescription)")
    }

    private func handleAppleCredential(credential: ASAuthorizationAppleIDCredential) {
        if let authorizationCode = credential.authorizationCode,
           let identityToken = credential.identityToken,
           let authString = String(data: authorizationCode, encoding: .utf8),
           let tokenString = String(data: identityToken, encoding: .utf8) {
            
            Task {
                do {
                    let success = try await postAppleLogin(identityToken: tokenString, authorizationCode: authString)
                    if success {
                        if isNewMember {
                            navigateToSignUp = true
                        } else {
                            navigateToHome = true
                        }
                    }
                } catch {
                    print("Apple login failed with error: \(error)")
                }
            }
        }
    }

    func postAppleLogin(identityToken: String, authorizationCode: String) async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            let appleLoginService = AppleLoginService()
            appleLoginService.postAppleLogin(identityToken: identityToken, authorizationCode: authorizationCode) { result in
                switch result {
                case .success(let response):
                    print("=====================================")
                    print("애플 로그인 결과: \(response)")
                    print("=====================================")
                    self.socialLoginViewModel.email = response.result.email
                    self.socialLoginViewModel.name = response.result.name
                    self.socialLoginViewModel.socialId = response.result.socialId
                    self.socialLoginViewModel.socialLoginType = "apple"
                    self.socialLoginViewModel.socialRefreshToken = response.result.refreshToken ?? ""
                    self.socialLoginViewModel.socialAccessToken = response.result.accessToken ?? ""
                    self.isNewMember = response.result.isNewMember
                    
                    continuation.resume(returning: true)
                case .failure(let error):
                    print("API Error: \(error)")
                    continuation.resume(returning: false)
                }
            }
        }
    }
}


// MARK: - AppleSignInButton
struct AppleSignInButton: View {
    @StateObject private var appleSignInHandler: AppleSignInHandler

    init(navigateToSignUp: Binding<Bool>, navigateToHome: Binding<Bool>, socialLoginViewModel: SocialLoginViewModel) {
            _appleSignInHandler = StateObject(wrappedValue: AppleSignInHandler(
                navigateToSignUp: navigateToSignUp,
                navigateToHome: navigateToHome,
                socialLoginViewModel: socialLoginViewModel
            ))
        }

    var body: some View {
        Button(action: handleAppleLogin) {
            HStack {
                Image("AppleIcon")
                    .resizable()
                    .frame(width: 18, height: 18)
                Text("Apple 계정으로 로그인")
                    .font(Font.Body1_SB)
                    .foregroundColor(.white)
            }
            .frame(width: 265, height: 37)
            .background(Color.black)
            .cornerRadius(5)
        }
    }

    private func handleAppleLogin() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.email, .fullName]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = appleSignInHandler
        controller.presentationContextProvider = appleSignInHandler
        controller.performRequests()
    }
}
