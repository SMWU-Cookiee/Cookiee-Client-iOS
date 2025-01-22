//
//  EventFormFields.swift
//  Cookiee
//
//  Created by minseo Kyung on 1/1/25.
//

import SwiftUI

public struct EventFormFields: View {
    @Binding var title: String
    @Binding var placeText: String
    @Binding var content: String
    @Binding var people: String
    
    @ObservedObject var categorySelectViewModel: CategorySelectViewModel
    @Binding var isCategorySelectButtonTapped: Bool
    
    public var body: some View {
        VStack {
            CustomTextFieldWithLabel(
                label: "쿠키 제목",
                text: $title,
                placeholder: "쿠키의 제목을 입력해주세요."
            )
            
            CustomTextFieldWithLabel(
                label: "장소",
                text: $placeText,
                placeholder: "장소를 직접 입력하거나 지도에서 선택해주세요."
            )
            
            CustomTextFieldWithLabel(
                label: "내용",
                text: $content,
                placeholder: "어떤 활동을 하셨나요?"
            )
            
            CustomTextFieldWithLabel(
                label: "함께한 사람",
                text: $people,
                placeholder: "함께한 사람들을 입력해주세요."
            )
            
            CategorySelectorView(
                categorySelectViewModel: categorySelectViewModel,
                isCategorySelectButtonTapped: $isCategorySelectButtonTapped
            )
        }
        .padding()
    }
}
