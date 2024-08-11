//
//  ContentView.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/11/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var isLaunching: Bool = true
       
       var body: some View {
           if isLaunching {
               SplashView()
                   .opacity(isLaunching ? 1 : 0)
                   .onAppear {
                       DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                           withAnimation(.easeIn(duration: 0.2)) {
                               isLaunching = false
                           }
                       }
                   }
           } else {
               SocialLoginView()
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
                        Image("CookieeIcon")
                    }
                    .position(x: geometry.size.width / 2, y: 216)
                    HStack {
                        Image("cookiee_typo")
                    }
                    .position(x: 0, y: 350)
                }
               
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.Beige)
    }
}
