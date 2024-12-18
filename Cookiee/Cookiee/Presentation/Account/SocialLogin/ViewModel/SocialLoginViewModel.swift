//
//  SocialLoginViewModel.swift
//  Cookiee
//
//  Created by minseo Kyung on 12/18/24.
//

import Foundation

class SocialLoginViewModel: ObservableObject {
    @Published var email: String?
    @Published var name: String?
    @Published var socialId: String?
    @Published var socialLoginType: String?
    @Published var socialRefreshToken: String?
    @Published var socialAccessToken: String?
}
