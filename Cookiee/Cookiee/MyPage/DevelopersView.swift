//
//  DevelopersView.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/24/24.
//

import SwiftUI

struct DevelopersView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

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
        VStack (alignment: .leading) {
            HStack {
                DevelopersInfoCardView(name: "경민서", role: "iOS Developer", email: "kyungminseo10@gmail.com", image: "kyungminseo")
                DevelopersInfoCardView(name: "조영서", role: "Backend Developer", email: "dudrhy12@gmail.com", image: "choyoungseo")
            }
            HStack {
                DevelopersInfoCardView(name: "황수연", role: "Design, Backend Developer", email: "syhhwang1231@gmail.com", image: "hwangsuyeon")
            }
            Spacer()
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Cookiee-를 만든 사람들👩‍🍳")
                    .font(.Head1_B)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .padding(.top, 10)
    }
}

#Preview {
    DevelopersView()
}

struct DevelopersInfoCardView : View {
    var name: String
    var role: String
    var email: String
    var image: String

    var body: some View {
        VStack (alignment: .leading) {
            VStack(alignment: .leading) {
                Text(name)
                    .font(.Body0_SB)
                    .padding(.top, 20)
                    .padding(.bottom, 1)
                Text(role)
                    .foregroundColor(.Brown02)
                    .font(.Body2_R)
                    .padding(.bottom, 10)
                Text(email)
                    .foregroundColor(.Gray04)
                    .font(.Body3_R)
            }
            .padding(.leading, 15)
            
            
            Image(image)
                .resizable()
                .frame(width: 174, height: 174)
        }
        .frame(width: 174)
        .overlay(
              RoundedRectangle(cornerRadius: 10)
                .stroke(Color.Brown03, lineWidth:0.5)
            )

        
    }
}
