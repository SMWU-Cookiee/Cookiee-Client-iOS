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
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
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
