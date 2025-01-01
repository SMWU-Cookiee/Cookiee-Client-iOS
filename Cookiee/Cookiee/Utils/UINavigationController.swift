//
//  UINavigationController.swift
//  Cookiee
//
//  Created by minseo Kyung on 1/1/25.
//

import UIKit
import SwiftUI

final class PopGestureManager {

    static let shared = PopGestureManager()
    private init() {}
    
    private(set) var isAllowPopGesture = true
    
    func updateAllowPopGesture(_ bool: Bool) {
        isAllowPopGesture = bool
    }
}

extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
                
        return PopGestureManager.shared.isAllowPopGesture && viewControllers.count > 1
    }
}

struct PopGestureDisabledViewModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .task {
                PopGestureManager.shared.updateAllowPopGesture(false)
            }
            .onDisappear {
                PopGestureManager.shared.updateAllowPopGesture(true)
            }
    }
}

extension View {
    
    func popGestureDisabled() -> some View {
        modifier(PopGestureDisabledViewModifier())
    }
}
