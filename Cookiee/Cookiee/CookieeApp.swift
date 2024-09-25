//
//  CookieeApp.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/11/24.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

@main
struct CookieeApp: App {
    @UIApplicationDelegateAdaptor var delegate: CookieeCustomDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class CookieeCustomDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}
