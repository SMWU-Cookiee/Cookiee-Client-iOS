//
//  CategoryEditView.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/21/24.
//

import SwiftUI

struct CategoryEditView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject private var viewModel = EventListViewModel()
    @State private var isModalOpen: Bool = false
    var date: Date?

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
    
    var body: some View {
        ScrollView {
            CategoryListView(color: "#000000")
            Spacer()
        }
        .navigationBarTitle(
            Text("카테고리 관리")
                .font(.Head1_B)
        )
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .padding()
        .padding(.top, 10)
    }
}

#Preview {
    CategoryEditView()
}

struct CategoryListView: View {
    @State var name: String = ""
    @State var color: String
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack {
            HStack {
                // 색상
                Rectangle()
                    .frame(width: 25, height: 25)
                    .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color(hex: color))
                // 이름
                HStack {
                    TextField("카테고리 이름을 입력해주세요", text: $name)
                        .focused($isTextFieldFocused)
                    // 편집 버튼
                    Button(action: {
                        isTextFieldFocused = true
                    }, label: {
                        Image("EditIconBrown")
                    })
                }
                .padding(10)
                .font(.Body1_M)
                .frame(height: 35)
                .background(Color.Gray01)
                .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                            
                // 삭제 버튼
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image("TrashIconRed")
                })
            }
            Divider()
        }
    }
}
