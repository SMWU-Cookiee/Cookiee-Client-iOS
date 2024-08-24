//
//  ColorPickerView.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/24/24.
//

import SwiftUI
import UIKit

struct ColorPickerView: View {
    @State var selectedColor: UIColor
    @State private var showColorPicker: Bool = false

    var body: some View {
        VStack {
            Button(action: {
                showColorPicker.toggle()
            }) {
                Rectangle()
                    .fill(Color(selectedColor))
                    .frame(width: 25, height: 25)
                    .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
            }
            .sheet(isPresented: $showColorPicker) {
                UIColorPickerViewControllerWrapper(selectedColor: $selectedColor) {
                    showColorPicker = false
                }
                .presentationDetents([.fraction(0.70)])
            }
        }
    }
}

struct UIColorPickerViewControllerWrapper: UIViewControllerRepresentable {
    @Binding var selectedColor: UIColor
    var onDismiss: () -> Void

    func makeUIViewController(context: Context) -> UIColorPickerViewController {
        let colorPicker = UIColorPickerViewController()
        colorPicker.selectedColor = selectedColor
        colorPicker.delegate = context.coordinator
        colorPicker.supportsAlpha = false
        return colorPicker
    }

    func updateUIViewController(_ uiViewController: UIColorPickerViewController, context: Context) {
        uiViewController.selectedColor = selectedColor
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIColorPickerViewControllerDelegate {
        var parent: UIColorPickerViewControllerWrapper

        init(_ parent: UIColorPickerViewControllerWrapper) {
            self.parent = parent
        }

        func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
            parent.onDismiss()
        }

        func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
            parent.selectedColor = color
        }
    }
}
