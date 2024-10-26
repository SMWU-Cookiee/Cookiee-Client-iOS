//
//  overlayIf.swift
//  Cookiee
//
//  Created by minseo Kyung on 10/26/24.
//

import SwiftUI

extension View {
    @ViewBuilder public func overlayIf<T: View>(
        _ condition: Bool,
        _ content: T,
        alignment: Alignment = .center
    ) -> some View {
        if condition {
            self.overlay(content, alignment: alignment)
        } else {
            self
        }
    }
}
