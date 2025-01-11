//
//  ContentView.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/11/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var isLaunching: Bool = true
    @State var tokenExpired: Bool = false
       
       var body: some View {
           if isLaunching {
               SplashView()
                   .opacity(isLaunching ? 1 : 0)
                   .onAppear {
                       DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                           withAnimation(.easeIn(duration: 0.2)) {
                               isLaunching = false
                               checkTokenStatus()
                           }
                       }
                   }
           } else {
               if tokenExpired {
                   SocialLoginView()
               } else {
                   TabBarView()
               }
           }
       }
    
    func checkTokenStatus() {
        isRefrehTokenExpired { expired in
            DispatchQueue.main.async {
                tokenExpired = expired
            }
        }
    }
    
    func isRefrehTokenExpired(completion: @escaping (Bool) -> Void) {
        let tokenRefreshService = TokenRefreshService()
        tokenRefreshService.postRefreshToken() { result in
            switch result {
            case .success(let response):
                print("🔐 postRefreshToken Response: \(response)")
                print("🔐 Access Token 재설정")
                saveToKeychain(key: "accessToken", data: response.result.accessToken)
                completion(false)
            case .failure(let error):
                print("🔐 postRefreshToken Error: \(error)")
                print("🔐 refresh 토큰 만료. 재로그인 필요")
                completion(true)
            }
        }
    }
}

#Preview {
    ContentView()
}

struct SplashView: View {
    
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
                    Text("오늘 하루를 사진으로 기록해\n나만의 쿠키를 만들어 보아요")
                        .foregroundStyle(Color.Brown01)
                        .font(Font.Body0_SB)
                }
                .position(x: geometry.size.width / 2, y: 50)
               
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.Beige)
        .navigationBarBackButtonHidden(true)
    }
}
