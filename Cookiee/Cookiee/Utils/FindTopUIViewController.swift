//
//  FindTopUIViewController.swift
//  Cookiee
//
//  Created by minseo Kyung on 9/25/24.
//

import Foundation
import UIKit


func FindTopUIViewController(controller: UIViewController? = nil) -> UIViewController? {
    let controller = controller ?? UIApplication.shared
        .connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .flatMap { $0.windows }
        .first { $0.isKeyWindow }?.rootViewController
    
    if let navigationController = controller as? UINavigationController {
        return FindTopUIViewController(controller: navigationController.visibleViewController)
    }
    if let tabController = controller as? UITabBarController {
        if let selected = tabController.selectedViewController {
            return FindTopUIViewController(controller: selected)
        }
    }
    if let presented = controller?.presentedViewController {
        return FindTopUIViewController(controller: presented)
    }
    return controller
}
