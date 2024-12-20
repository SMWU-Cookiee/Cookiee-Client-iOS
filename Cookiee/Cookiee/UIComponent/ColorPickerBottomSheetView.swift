//
//  ColorPickerBottomSheetView.swift
//  Cookiee
//
//  Created by minseo Kyung on 12/20/24.
//

import SwiftUI

struct ColorPickerBottomSheetView: View {
    @Binding var isPresented: Bool
    @Binding var selectedColor: String
    
    var body: some View {
        VStack {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        isPresented = false
                    }
                }
            ZStack {
                UIColorPickerViewControllerWrapper(selectedColor: $selectedColor) {
                    withAnimation {
                        isPresented = false
                    }
                }
                .frame(height: 520)
            }
            .background(Color.white)
            .zIndex(1)
        }
    }
}
