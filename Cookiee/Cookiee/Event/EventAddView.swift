//
//  EventAddView.swift
//  Cookiee
//
//  Created by minseo Kyung on 9/18/24.
//

import SwiftUI

struct EventAddView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    // 백 버튼 커스텀
    var backButton: some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            HStack {
                Image("ChevronLeftIconBlack")
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
    
    @State var title: String = ""
    @State var place: String = ""
    @State var content: String = ""
    @State var people: String = ""
    
    
   
    var body: some View {
        VStack {
            VStack {
                EventInfoTextField(fieldName: "쿠키 제목", placeholder: "쿠키의 제목을 입력해주세요.", field: title)
                EventInfoTextField(fieldName: "장소", placeholder: "장소를 입력해주세요.", field: place)
                EventInfoTextField(fieldName: "내용", placeholder: "어떤 활동을 하셨나요?", field: content)
                EventInfoTextField(fieldName: "함께한 사람", placeholder: "함께한 사람들을 입력해주세요.", field: people)
                
                VStack(alignment: .leading) {
                    Text("카테고리")
                        .font(.Body1_M)
                        .foregroundStyle(Color.Gray05)
                        .frame(width: 75, alignment: .leading)
                    Button(action: {
                        
                    }) {
                        HStack {
                            Text("카테고리를 선택해주세요.")
                                .font(.Body0_M)
                                .foregroundStyle(Color.Black)
                            Spacer()
                            Image("UnderDropBlack")
                                .padding(2)
                        }
                        .padding(10)
                        .frame(height: 40)
                        .background(Color.Gray01)
                        .cornerRadius(5)
                        
                    }
                        
                }
                .padding(.bottom, 25)
                
            }
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("쿠키 추가하기")
                    .font(.Head1_B)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .navigationBarItems(trailing: Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
            Text("완료")
                .font(.Body0_B)
                .foregroundColor(.Gray03)
        }))

        .padding()
        .padding(.top, 10)
    }
}

struct EventInfoTextField : View {
    
    var fieldName: String
    var placeholder: String
    @State var field: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(fieldName)
                .font(.Body1_M)
                .foregroundStyle(Color.Gray05)
                .frame(width: 75, alignment: .leading)
            
            TextField("", text: $field)
                .placeholder(when: field.isEmpty) {
                    Text(placeholder)
                        .foregroundStyle(Color.Gray04)
                        .font(.Body0_M)
            }
            .padding(10)
            .frame(height: 40)
            .background(Color.Gray01)
            .cornerRadius(5)
        }
        .padding(.bottom, 25)
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: .leading) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

#Preview {
    EventAddView()
}
