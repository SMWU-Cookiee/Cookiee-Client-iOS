//
//  ColorPickerView.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/24/24.
//

import SwiftUI
import UIKit

struct UIColorPickerViewControllerWrapper: UIViewControllerRepresentable {
    @Binding var selectedColor: String
    var onDismiss: () -> Void

    func makeUIViewController(context: Context) -> UIViewController {
        let container = UIViewController()
        let colorPicker = UIColorPickerViewController()

        if let uiColor = UIColor(named: selectedColor) {
            colorPicker.selectedColor = uiColor
        }

        colorPicker.delegate = context.coordinator
        colorPicker.supportsAlpha = false

        container.addChild(colorPicker)
        container.view.addSubview(colorPicker.view)
        colorPicker.didMove(toParent: container)

        colorPicker.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorPicker.view.topAnchor.constraint(equalTo: container.view.topAnchor),
            colorPicker.view.bottomAnchor.constraint(equalTo: container.view.bottomAnchor),
            colorPicker.view.leadingAnchor.constraint(equalTo: container.view.leadingAnchor),
            colorPicker.view.trailingAnchor.constraint(equalTo: container.view.trailingAnchor)
        ])

        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(named: "CloseButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        closeButton.addTarget(context.coordinator, action: #selector(context.coordinator.dismiss), for: .touchUpInside)

        container.view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: container.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: container.view.trailingAnchor, constant: -10),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30)
        ])

        return container
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIColorPickerViewControllerDelegate {
        var parent: UIColorPickerViewControllerWrapper

        init(_ parent: UIColorPickerViewControllerWrapper) {
            self.parent = parent
        }

        @objc func dismiss() {
            parent.onDismiss()
        }

        func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
            parent.onDismiss()
        }

        func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
            parent.selectedColor = color.toHexString()
        }
    }
}
