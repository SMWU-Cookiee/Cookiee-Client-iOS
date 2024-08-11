//
//  ColorExtension.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/11/24.
//

import SwiftUI

extension Color {
    static let Beige = Color(hex: "#F6F1E4")
    static let Brown00 = Color(hex: "#594E4E")
    static let Brown01 = Color(hex: "#756767")
    static let Brown02 = Color(hex: "#8F8181")
    static let Brown03 = Color(hex: "#AA9E9E")
    static let Black = Color(hex: "#000000")
    static let Gray07 = Color(hex: "#23272B")
    static let Gray06 = Color(hex: "#40464B")
    static let Gray05 = Color(hex: "#717981")
    static let Gray04 = Color(hex: "#A1AAB3")
    static let Gray03 = Color(hex: "#C7CCD2")
    static let Gray02 = Color(hex: "#DEE2E6")
    static let Gray01 = Color(hex: "#EEEFF3")
    static let Gray00 = Color(hex: "#F5F6FA")
    static let White = Color(hex: "#FFFFFF")
    static let Error = Color(hex: "#FF6E6E")
}

extension Color {
    // 16진수->rgb 변환
    init(hex: String) {
    let scanner = Scanner(string: hex)
    _ = scanner.scanString("#")

    var rgb: UInt64 = 0
    scanner.scanHexInt64(&rgb)

    let r = Double((rgb >> 16) & 0xFF) / 255.0
    let g = Double((rgb >>  8) & 0xFF) / 255.0
    let b = Double((rgb >>  0) & 0xFF) / 255.0
    self.init(red: r, green: g, blue: b)
    }
}
