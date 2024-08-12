//
//  DateView.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/12/24.
//

import SwiftUI

struct DateView: View {
    // Back 버튼 커스텀
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var backButton : some View {
            Button{
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                HStack {
                    Image("ChevronLeftIcon")
                        .aspectRatio(contentMode: .fit)
                }
            }
        }

    var date: Date?
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: .bottomLeading) {
                    HStack {
                        Image("testimage")
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: 270)
                            .clipped()
                        
                    }
                    .overlay(LinearGradient(gradient: Gradient(colors: [Color.white.opacity(1.0), Color.white.opacity(0.75), .clear]), startPoint: .bottom, endPoint: .top)
                                        .frame(height: 35),
                             alignment: .bottom)
                    HStack {
                        Text("\(date!, formatter: Self.dateFormatter)")
                            .foregroundStyle(Color.Brown00)
                            .font(.Head0_B_22)
                    }
                    .padding(7)
                }
                .edgesIgnoringSafeArea(.top)
            }
            .navigationBarBackButtonHidden(true) // Back 버튼 커스텀
            .navigationBarItems(leading: backButton)
        }
    }
}

#Preview {
    DateView(date: Date.now)
}

extension DateView {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"

        return formatter
    }()
}
