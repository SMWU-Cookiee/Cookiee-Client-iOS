//
//  ColorPickerView.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/24/24.
//

import SwiftUI
import UIKit

//struct ColorPickerView: View {
//    @State var selectedColor: UIColor
//    @State private var showColorPicker: Bool = false
//
//    var body: some View {
//        VStack {
//            Button(action: {
//                showColorPicker.toggle()
//            }) {
//                if isNew {
//                    Text("탭하여 색 선택하기")
//                        .foregroundStyle(Color.Gray04)
//                } else {
//                    Rectangle()
//                        .fill(Color(selectedColor))
//                        .frame(width: 25, height: 25)
//                        .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
//                }
//            }
//            .sheet(isPresented: $showColorPicker) {
//                UIColorPickerViewControllerWrapper(selectedColor: $selectedColor, isNew: $isNew) {
//                    showColorPicker = false
//                }
//                .presentationDetents([.fraction(0.70)])
//            }
//        }
//    }
//}

struct UIColorPickerViewControllerWrapper: UIViewControllerRepresentable {
    @Binding var selectedColor: String
    var onDismiss: () -> Void

    func makeUIViewController(context: Context) -> UIColorPickerViewController {
        let colorPicker = UIColorPickerViewController()
        colorPicker.selectedColor = UIColor(Color(hex: selectedColor))
        colorPicker.delegate = context.coordinator
        colorPicker.supportsAlpha = false
        return colorPicker
    }

    func updateUIViewController(_ uiViewController: UIColorPickerViewController, context: Context) {
        uiViewController.selectedColor = UIColor(Color(hex: selectedColor))
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

        private func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: String, continuously: Bool) {
            parent.selectedColor = color
        }
    }
}
